defmodule ThreemaGateway.IncomingMessage do
  use JsonStruct
  alias ThreemaGateway.Crypto
  alias ThreemaGateway.IncomingMessage
  alias ThreemaGateway.InvalidMacError

  json_struct do
    field :from, json: "from"
    field :to, json: "to"
    field :message_id, json: "messageId"
    field :date, json: "date", decode: &String.to_integer(&1)
    field :nonce, json: "nonce", decode: &Base.decode16!(&1, case: :lower)
    field :box_data, json: "box", decode: &Base.decode16!(&1, case: :lower)
    field :nickname, json: "nickname"
  end

  def from_url_encoded(payload, api_secret) when is_binary(payload) do
    data = URI.decode_query(payload, %{}, :www_form)

    try do
      case validate_hmac(data, api_secret) do
        true ->
          {:ok, IncomingMessage.from_string_map(data)}

        false ->
          {:error, InvalidMacError}
      end
    catch
      e -> {:error, e}
    end
  end

  def from_url_encoded!(payload, api_secret) when is_binary(payload) do
    case from_url_encoded(payload, api_secret) do
      {:ok, msg} -> msg
      {:error, error} -> raise error
    end
  end

  def decrypt_box(%__MODULE__{} = msg, public_key, secret_key) do
    Crypto.decrypt_box(msg.box_data, msg.nonce, public_key, secret_key)
  end

  def decrypt_box!(%__MODULE__{} = msg, public_key, secret_key) do
    case decrypt_box(msg, public_key, secret_key) do
      {:ok, data} -> data
      {:error, error} -> raise error
    end
  end

  def validate_hmac(data, secret) do
    mac = Base.decode16!(data["mac"], case: :lower)
    calculated = calculate_hmac(data, secret)
    :crypto.hash_equals(mac, calculated)
  end

  defp calculate_hmac(data, secret) do
    fields =
      for field <- ["from", "to", "messageId", "date", "nonce", "box"], do: data[field], into: ""

    :crypto.mac(:hmac, :sha256, secret, fields)
  end
end
