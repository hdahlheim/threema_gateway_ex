defmodule ThreemaGateway.FileMessageTest do
  use ExUnit.Case

  alias ThreemaGateway.FileMessage

  test "file message json encoding and decoding" do
    file_message = %FileMessage{
      file_blob_id: "aaaa-bbbb-cccc-dddd-eeee",
      file_name: "test_file",
      description: "test file"
    }

    json = Jason.encode!(file_message)

    map = Jason.decode!(json)
    assert file_message == FileMessage.from_string_map(map)
  end
end
