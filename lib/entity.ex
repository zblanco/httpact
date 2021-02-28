defprotocol HTTPact.Entity do
  @moduledoc """
  Provides a contract for an API Wrapper to convert responses into a return type.
  """
  @fallback_to_any true
  def from_response(response, source_command)
end

defimpl HTTPact.Entity, for: Any do
  def from_response(response, _), do: response
end

defimpl HTTPact.Entity, for: HTTPact.Request do
  def from_response(request, _), do: request
end
