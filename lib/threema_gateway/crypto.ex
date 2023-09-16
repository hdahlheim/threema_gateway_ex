defmodule ThreemaGateway.Crypto do
  alias ThreemaGateway.Crypto.DecryptionFailedError
  alias ThreemaGateway.EncryptedMessage

  @file_nonce <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>
  @thumb_nonce <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2>>
  @nonce_bytes :enacl.box_NONCEBYTES()

  @text_msg_byte <<0x01>>
  @image_msg_byte <<0x02>>
  @video_msg_byte <<0x13>>
  @file_msg_byte <<0x17>>
  @deliveryreceipt_msg_byte <<0x80>>

  def encrypt_msg(data, msg_type, public_key, private_key) do
    padding =
      random_padding_amount()
      |> gen_padding()

    msg_type_byte =
      case msg_type do
        :text -> @text_msg_byte
        :image -> @image_msg_byte
        :video -> @video_msg_byte
        :file -> @file_msg_byte
        :deliveryreceipt -> @deliveryreceipt_msg_byte
      end

    padded_plain = [msg_type_byte, data, padding]

    encrypt_padded(padded_plain, public_key, private_key)
  end

  def encrypt_image_msg(blob_id, img_size_bytes, image_data_nonce, public_key, private_key) do
    data = <<blob_id::binary-16, img_size_bytes::little-unsigned-32, image_data_nonce::binary-24>>

    encrypt_msg(data, :image, public_key, private_key)
  end

  def encrypt_file_msg(file_msg, public_key, private_key) do
    file_msg
    |> Jason.encode!()
    |> encrypt_msg(:file, public_key, private_key)
  end

  def encrypt_padded(box, public_key, private_key, nonce \\ gen_nonce()) do
    {:ok, ciphertext} = :enacl.box_easy(box, nonce, public_key, private_key)
    EncryptedMessage.new(ciphertext, nonce)
  end

  def decrypt_box(box, nonce, public_key, private_key) do
    case :enacl.box_open_easy(box, nonce, public_key, private_key) do
      {:ok, <<msg_type::8, padded_data::binary>>} ->
        data = remove_padding(padded_data)

        data =
          case <<msg_type::8>> do
            @text_msg_byte -> data
            @image_msg_byte -> data
            @video_msg_byte -> data
            @file_msg_byte -> data
            _ -> :todo
          end

        {:ok, data}

      {:error, _} ->
        {:error, DecryptionFailedError}
    end
  end

  def gen_nonce do
    :enacl.randombytes(@nonce_bytes)
  end

  def file_nonce() do
    @file_nonce
  end

  def thumb_nonce() do
    @thumb_nonce
  end

  @doc """
  Generates a random number in the inclusive range of 1 to 255
  """
  def random_padding_amount do
    :enacl.randombytes_uniform(254) + 1
  end

  def gen_padding(amount) do
    gen = Stream.repeatedly(fn -> amount end)

    for byte <- Enum.take(gen, amount), do: <<byte::8>>, into: <<>>
  end

  def remove_padding(padded) do
    padded
    |> binary_change_endian_to(:little)
    |> then(fn <<padding_size::8, _::binary-size(padding_size - 1), rev_msg::binary>> ->
      rev_msg
    end)
    |> binary_change_endian_to(:big)
  end

  defp binary_change_endian_to(binary, to) when to in [:big, :little] do
    case to do
      :little ->
        binary
        |> :binary.decode_unsigned(:big)
        |> :binary.encode_unsigned(:little)

      :big ->
        binary
        |> :binary.decode_unsigned(:little)
        |> :binary.encode_unsigned(:big)
    end
  end
end
