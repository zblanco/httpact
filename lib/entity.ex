defprotocol HTTPact.Entity do
  @moduledoc """
  Provides a contract for an API Wrapper to convert responses into a return type.
  """
  def from_response(source_command, response)
end

defimpl HTTPact.Entity, for: HTTPact.Request do
  def from_response(%HTTPact.Request{}, response), do: response
end
