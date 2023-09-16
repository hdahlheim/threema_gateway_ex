defmodule ThreemaGateway.CryptoTest do
  use ExUnit.Case

  alias ThreemaGateway.Crypto
  alias ThreemaGateway.IncomingMessage

  test "decrypt" do
    msg_content = "secert"
    %{ public: a_pk, secret: a_sk } = :enacl.box_keypair()
    %{ public: b_pk, secret: b_sk } = :enacl.box_keypair()

    msg = Crypto.encrypt_msg(msg_content, :text, b_pk, a_sk)

    in_msg =
      %IncomingMessage{
        from: "AAAAAAAA",
        to: "BBBBBBB",
        message_id: "00112233",
        date: 0,
        nonce: msg.nonce,
        box_data: msg.ciphertext
      }

    assert {:error, Crypto.DecryptionFailedError} =
             IncomingMessage.decrypt_box(in_msg, b_pk, b_sk)

    assert_raise Crypto.DecryptionFailedError, fn ->
      IncomingMessage.decrypt_box!(in_msg, b_pk, b_sk)
    end

    {:ok, decrypted} = IncomingMessage.decrypt_box(in_msg, a_pk, b_sk)

    assert msg_content == decrypted
  end

  test "random uniform" do
    for _ <- 1..500 do
      random_pad = Crypto.random_padding_amount()
      assert random_pad >= 1
      assert random_pad <= 255
    end
  end

  test "random not stuck" do
    num =
      for _ <- 1..100, into: [] do
        Crypto.random_padding_amount()
      end

    assert Enum.uniq(num) > 1
  end
end
