defprotocol ThreemaGateway.API.Client do
  def lookup_pubkey(api_client, id)
  def lookup_id(api_client, criterion)
  def lookup_capabilities(api_client, id)
  def lookup_credits(api_client)
  def send(api_client, to, message, delivery_receipts)
end
