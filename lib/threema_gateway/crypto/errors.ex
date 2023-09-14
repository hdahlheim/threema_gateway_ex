defmodule ThreemaGateway.Crypto.DecryptionFailedError do
  defexception [:message]

  @impl true
  def exception(_value) do
    msg = "decryption failed"
    %__MODULE__{message: msg}
  end
end

defmodule ThreemaGateway.Crypto.BadNonceError do
  defexception [:message]

  @impl true
  def exception(_value) do
    msg = "bad nonce"
    %__MODULE__{message: msg}
  end
end

defmodule ThreemaGateway.Crypto.BadPaddingError do
  defexception [:message]

  @impl true
  def exception(_value) do
    msg = "bad padding"
    %__MODULE__{message: msg}
  end
end
