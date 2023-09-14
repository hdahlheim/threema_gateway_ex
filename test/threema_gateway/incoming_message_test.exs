defmodule ThreemaGateway.IncomingMessageTest do
  use ExUnit.Case
  alias ThreemaGateway.IncomingMessage

  doctest IncomingMessage

  test "parse from url encoded" do
    payload =
      "from=ECHOECHO&to=*TESTTST&messageId=0102030405060708&date=1616950936&nonce=ffffffffffffffffffffffffffffffffffffffffffffffff&box=012345abcdef&mac=622b362e8353658ee649a5548acecc9ce9b88384d6b7e08e212446d68455b14e"

    secret = "nevergonnagiveyouup"

    assert {:ok, %IncomingMessage{} = msg} = IncomingMessage.from_url_encoded(payload, secret)
    assert msg.from == "ECHOECHO"
    assert msg.message_id == "0102030405060708"
    assert msg.to == "*TESTTST"
    assert msg.date == 1_616_950_936
  end
end
