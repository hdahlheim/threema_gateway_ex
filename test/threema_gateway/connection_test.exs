defmodule ThreemaGatewayEx.ConnectionTest do
  alias ThreemaGateway.Connection
  use ExUnit.Case

  test "simple max length too long" do
    generator = Stream.repeatedly(fn -> "à" end)

    msg =
      generator
      |> Enum.take(div(3500, 2))
      |> List.to_string()

    msg = msg <> "x"

    assert byte_size(msg) == 3501

    assert {:error, ThreemaGateway.MessageToLongError} =
             Connection.send_simple(nil, "", "AAAAAAAA", "BBBBBBBB", "not_needed", msg)
  end
end
