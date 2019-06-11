defprotocol HTTPact.Command do
  @moduledoc """
  More decomposed protocol than `Operation` for strict Command -> Request conversions.
  """
  def to_request(command)
end
