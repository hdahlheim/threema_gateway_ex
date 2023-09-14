defmodule ThreemaGateway.API do
  alias ThreemaGateway.API.{SimpleApi, E2EApi, Client}

  defmacro __using__(_) do
    quote do
      alias ThreemaGateway.Lookup

      def new(args) do
        struct!(__MODULE__, args)
      end

      def lookup_id(client, criterion) do
        Lookup.lookup_id(
          client.http_client,
          client.endpoint,
          criterion,
          client.id,
          client.secret
        )
      end

      def lookup_pubkey(client, id) do
        Lookup.lookup_pubkey(
          client.http_client,
          client.endpoint,
          client.id,
          id,
          client.secret
        )
      end

      def lookup_capabilities(client, id) do
        Lookup.lookup_capabilities(
          client.http_client,
          client.endpoint,
          client.id,
          id,
          client.secret
        )
      end

      def lookup_credits(client) do
        Lookup.lookup_credits(
          client.http_client,
          client.endpoint,
          client.id,
          client.secret
        )
      end
    end
  end

  def new_simple_client(args) do
    SimpleApi.new(args)
  end

  def new_e2e_client(args) do
    E2EApi.new(args)
  end

  def lookup_pubkey(client, id) do
    Client.lookup_pubkey(client, id)
  end

  def lookup_id(client, criterion) do
    Client.lookup_id(client, criterion)
  end

  def lookup_capabilities(client, id) do
    Client.lookup_capabilities(client, id)
  end

  def lookup_credits(client) do
    Client.lookup_credits(client)
  end

  def send(client, to, message, delivery_receipts \\ false) do
    Client.send(client, to, message, delivery_receipts)
  end
end
