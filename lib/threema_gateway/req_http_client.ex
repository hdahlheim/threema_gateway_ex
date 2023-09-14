defmodule ThreemaGateway.ReqHttpClient do
  @behaviour ThreemaGateway.HttpClient

  @impl true
  def get(url, headers) do
    with {:ok, res} <- Req.get(url, headers: headers) do
      {:ok, res.status, res.headers, res.body}
    end
  end

  @impl true
  def post(url, headers, body) do
    with {:ok, res} <- Req.post(url, body: Jason.encode!(body), headers: headers) do
      {:ok, res.status, res.headers, res.body}
    end
  end
end
