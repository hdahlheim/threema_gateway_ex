defmodule ThreemaGateway.Crypto.RecipientKeyTest do
  use ExUnit.Case

  alias ThreemaGateway.Crypto.RecipientKey

  test "from string" do
    encoded_key = "5cf143cd8f3652f31d9b44786c323fbc222ecfcbb8dac5caf5caa257ac272df0"
    assert %RecipientKey{} = RecipientKey.from_string!(encoded_key)

    to_short_key = "5cf143cd8f3652f31d9b44786c323fbc222ecfcbb8dac5ca"

    assert_raise ArgumentError, fn ->
      RecipientKey.from_string!(to_short_key)
    end
  end
end
