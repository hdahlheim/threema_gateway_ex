defmodule ThreemaGateway.HttpClient do
  @type status() :: 100..599
  @type headers() :: [{String.t(), String.t()}]
  @type body() :: binary()

  @callback get(url :: String.t(), headers()) ::
              {:ok, status(), headers(), body()} | {:error, term()}

  @callback post(url :: String.t(), headers(), body()) ::
              {:ok, status(), headers(), body()} | {:error, term()}
end
