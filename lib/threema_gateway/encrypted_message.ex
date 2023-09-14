defmodule ThreemaGateway.EncryptedMessage do
  defstruct ciphertext: <<>>,
            nonce: <<>>

  def new(ciphertext, nonce) when byte_size(nonce) == 24 do
    struct!(__MODULE__, ciphertext: ciphertext, nonce: nonce)
  end
end
