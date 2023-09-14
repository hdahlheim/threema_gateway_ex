defmodule ThreemaGateway.FileMessage do
  use JsonStruct

  json_struct do
    field :file_blob_id, json: "b"
    field :file_media_type, json: "m"
    field :thumbnail_blob_id, json: "t", optional: true
    field :thumbnail_media_type, json: "p", optional: true
    field :blob_encryption_key, json: "k"
    field :file_name, json: "n", optional: true
    field :file_byte_size, json: "s"
    field :description, json: "d", optional: true
    field :rendering_type, json: "j"
    field :legacy_rendering_type, json: "i"
    field :metadat, json: "x", optional: true
  end

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
