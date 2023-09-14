defmodule ThreemaGateway.FileMetadata do
  use JsonStruct

  json_struct do
    field :animated, json: "a", optional: true
    field :height, json: "h", optional: true
    field :width, json: "w", optional: true
    field :duration_seconds, json: "d", optional: true
  end
end
