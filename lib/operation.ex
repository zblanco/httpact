defprotocol HTTPact.Operation do
  @moduledoc """
  Protocol for REST API clients utilizing the HTTPact contracts to utilize requests and responses.
  """
  def to_request(operation, client)

  def from_response(operation, response, client)
end
