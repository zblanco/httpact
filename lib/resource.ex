defprotocol HTTPact.Resource do
  @moduledoc """
  More decomposed protocol than `Operation` for strict Response -> Resource conversions.
  """
  def from_response(resource, response)
end
