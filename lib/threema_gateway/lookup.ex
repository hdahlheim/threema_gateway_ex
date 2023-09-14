defmodule ThreemaGateway.Lookup do
  require Logger
  alias ThreemaGateway.Connection

  def lookup_pubkey(http_client, endpoint, our_id, their_id, secret) do
    url = "#{endpoint}/pubkeys/#{their_id}?from=#{our_id}&secret=#{secret}"

    Logger.debug("Lookup pubkey #{url}")

    with {:ok, status_code, _headers, body} <-
           http_client.get(url, []),
         :ok <- Connection.map_status_to_error(status_code) do
      body
    end
  end

  def lookup_id(http_client, endpoint, criterion, our_id, secret) do
    url_base =
      case criterion do
        {:phone, value} -> "#{endpoint}/lookup/phone/#{value}"
        {:phone_hash, value} -> "#{endpoint}/lookup/phone_hash/#{value}"
        {:email, value} -> "#{endpoint}/lookup/email/#{value}"
        {:email_hash, value} -> "#{endpoint}/lookup/email_hash/#{value}"
        _ -> raise "Invalid criterion"
      end

    url = "#{url_base}?from=#{our_id}&secret=#{secret}"

    with {:ok, status_code, _headers, body} <-
           http_client.get(url, []),
         :ok <- Connection.map_status_to_error(status_code) do
      body
    end
  end

  def lookup_capabilities(http_client, endpoint, our_id, their_id, secret) do
    url = "#{endpoint}/capabilities/#{their_id}?from=#{our_id}&secret=#{secret}"

    with {:ok, status_code, _headers, body} <-
           http_client.get(url, []),
         :ok <- Connection.map_status_to_error(status_code) do
      body
    end
  end

  def lookup_credits(http_client, endpoint, our_id, secret) do
    url = "#{endpoint}/credits?from=#{our_id}&secret=#{secret}"

    with {:ok, status_code, _headers, body} <-
           http_client.get(url, []),
         :ok <- Connection.map_status_to_error(status_code) do
      body
    end
  end
end
