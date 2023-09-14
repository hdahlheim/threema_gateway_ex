defmodule ThreemaGateway.Crypto.RecipientKey do
  defstruct public_key: <<>>

  def from_public_key(key) when byte_size(key) == 32 do
    {:ok, struct!(__MODULE__, public_key: key)}
  end

  def from_binary(key) when byte_size(key) == 32 do
    {:ok, struct!(__MODULE__, public_key: key)}
  end

  def from_binary(key) when byte_size(key) < 32 do
    {:error, "to short"}
  end

  def from_string!(hex_key) when byte_size(hex_key) == 64 do
    key = Base.decode16!(hex_key, case: :mixed)
    struct!(__MODULE__, public_key: key)
  end

  def from_string!(hex_key) when byte_size(hex_key) < 64 do
    raise ArgumentError, "key to short"
  end

  defimpl String.Chars do
    alias ThreemaGateway.Crypto.RecipientKey

    def to_string(%RecipientKey{} = key) do
      Base.encode16(key.public_key, case: :lower)
    end
  end
end
