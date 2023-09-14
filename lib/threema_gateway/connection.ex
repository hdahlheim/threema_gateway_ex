defmodule ThreemaGateway.Connection do
  alias ThreemaGateway.MessageToLongError

  def send_simple(http_client, endpoint, from, to, secret, text) do
    case byte_size(text) < 3500 do
      true ->
        body = %{
          from: from,
          secret: secret,
          text: text
        }

        body =
          case to do
            {:id, id} -> Map.put(body, :to, id)
            {:email, email} -> Map.put(body, :email, email)
            {:phone, phone} -> Map.put(body, :phone, phone)
            _ -> raise "Invalid 'to' target"
          end

        with {:ok, status_code, _headers, res_body} <-
               http_client.post(
                 endpoint,
                 [{"content-type", "application/x-www-form-urlencoded"}, {"accept", "*/*"}],
                 body
               ),
             :ok <- map_status_to_error(status_code, :bad_sender_or_recipient),
             {:ok, data} <- URI.encode_query(res_body, :www_form) do
          {:ok, data}
        end

      false ->
        {:error, MessageToLongError}
    end
  end

  def send_e2e(http_client, endpoint, from, to, secret, nonce, ciphertext, delivery_receipts) do
    body = %{
      from: from,
      to: to,
      secret: secret,
      nonce: Base.decode16!(nonce, case: :lower),
      box: Base.decode16!(ciphertext, case: :lower),
      noDeliveryReceipts: if(not delivery_receipts, do: "1", else: "0")
    }

    with {:ok, status_code, _headers, res_body} <-
           http_client.post(
             endpoint,
             [
               {"content-type", "application/x-www-form-urlencoded"},
               {"accept", "application/json"}
             ],
             Jason.encode!(body)
           ),
         :ok <- map_status_to_error(status_code, :bad_sender_or_recipient),
         {:ok, data} <- URI.encode_query(res_body, :www_form) do
      {:ok, data}
    end
  end

  def blob_upload() do
    :todo
  end

  def blob_download() do
    :todo
  end

  def map_status_to_error(status_code, other \\ :bad_request) do
    case status_code do
      200 -> :ok
      400 -> {:error, other}
      401 -> {:error, :bad_credentials}
      402 -> {:error, :no_credits}
      404 -> {:error, :id_not_found}
      413 -> {:error, :message_too_long}
      500 -> {:error, :server_error}
      code -> {:error, "Bad response status code #{code}"}
    end
  end
end
