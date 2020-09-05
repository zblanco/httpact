defprotocol HTTPact.Command do
  @moduledoc """
  Allows a datastructure defining a API Wrapper's valid command to be converted into an HTTPact Request.
  """
  def to_request(command)
end
