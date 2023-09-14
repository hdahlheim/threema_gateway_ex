defmodule ThreemaGateway.Capabilities do
  defstruct text: false,
            image: false,
            video: false,
            audio: false,
            file: false,
            other: []

  def new() do
    struct!(__MODULE__, [])
  end
end
