defprotocol HTTPact.Entity do
  @moduledoc """
  More decomposed protocol than `Operation` for strict Response -> Entity conversions.
  """
  def from_response(entity, response)
end
