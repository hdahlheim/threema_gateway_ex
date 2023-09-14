defmodule ThreemaGateway.API.E2EApi do
  use ThreemaGateway.API

  @derive {Inspect, only: [:id, :endpoint, :http_client]}
  defstruct id: "",
            private_key: "",
            secret: "",
            endpoint: "",
            http_client: nil

  defimpl ThreemaGateway.API.Client do
    alias ThreemaGateway.Crypto
    alias ThreemaGateway.Crypto.RecipientKey
    alias ThreemaGateway.API.E2EApi
    alias ThreemaGateway.Connection
    alias ThreemaGateway.EncryptedMessage

    def lookup_id(client, id) do
      E2EApi.lookup_id(client, id)
    end

    def lookup_credits(client) do
      E2EApi.lookup_credits(client)
    end

    def lookup_pubkey(client, id) do
      E2EApi.lookup_pubkey(client, id)
    end

    def lookup_capabilities(client, id) do
      E2EApi.lookup_capabilities(client, id)
    end

    def encrypt_text_msg(%E2EApi{} = client, text, %RecipientKey{} = recipient_key) do
      Crypto.encrypt_msg(text, :text, recipient_key.public_key, client.private_key)
    end

    def encrypt_image_msg(%E2EApi{} = client, text, %RecipientKey{} = recipient_key) do
      Crypto.encrypt_msg(text, :image, recipient_key.public_key, client.private_key)
    end

    def encrypt_file_msg(%E2EApi{} = client, text, %RecipientKey{} = recipient_key) do
      Crypto.encrypt_msg(text, :file, recipient_key.public_key, client.private_key)
    end

    def send(%E2EApi{} = client, to, %EncryptedMessage{} = message, delivery_receipts) do
      Connection.send_e2e(
        client.http_client,
        client.endpoint,
        client.id,
        to,
        client.secret,
        message.nonce,
        message.ciphertext,
        delivery_receipts
      )
    end
  end
end
