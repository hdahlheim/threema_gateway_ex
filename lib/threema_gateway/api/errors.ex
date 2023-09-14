defmodule ThreemaGateway.API.InvalidMacError do
  defexception [:message]

  @impl true
  def exception(_value) do
    msg = "bad MAC"
    %__MODULE__{message: msg}
  end
end

defmodule ThreemaGateway.API.MessageToLongError do
  defexception [:message]

  @impl true
  def exception(_value) do
    msg = "message is too long"
    %__MODULE__{message: msg}
  end
end
