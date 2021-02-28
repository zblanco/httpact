defprotocol HTTPact.Entity do
  @moduledoc """
  Provides a contract for an API Wrapper to convert responses into a return type.
  """
  def from_response(response, source_command)
end

defimpl HTTPact.Entity, for: HTTPact.Response do
  def from_response(response, %HTTPact.Request{}), do: response
end
