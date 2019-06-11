defprotocol HTTPact.Operation do
  @moduledoc """
  Protocol to enforce the conversion of Requests and Responses to and from Commands and Entities.
  """
  def to_request(operation)
  def from_response(operation, response)
end
