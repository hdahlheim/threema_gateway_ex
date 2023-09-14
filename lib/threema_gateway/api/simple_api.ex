defmodule ThreemaGateway.API.SimpleApi do
  use ThreemaGateway.API

  @derive {Inspect, only: [:id, :endpoint, :http_client]}
  defstruct id: "",
            secret: "",
            endpoint: "",
            http_client: nil

  defimpl ThreemaGateway.API.Client do
    alias ThreemaGateway.Connection
    alias ThreemaGateway.API.SimpleApi

    def lookup_id(client, criterion) do
      SimpleApi.lookup_id(client, criterion)
    end

    def lookup_credits(client) do
      SimpleApi.lookup_credits(client)
    end

    def lookup_pubkey(client, id) do
      SimpleApi.lookup_pubkey(client, id)
    end

    def lookup_capabilities(client, id) do
      SimpleApi.lookup_capabilities(client, id)
    end

    def send(%SimpleApi{} = client, to, message, _delivery_receipts) do
      Connection.send_simple(
        client.http_client,
        client.endpoint,
        client.id,
        to,
        client.secret,
        message
      )
    end
  end
end
