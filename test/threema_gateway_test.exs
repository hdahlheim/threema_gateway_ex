defmodule ThreemaGatewayTest do
  use ExUnit.Case
  doctest ThreemaGateway

  test "greets the world" do
    assert ThreemaGateway.hello() == :world
  end
end
