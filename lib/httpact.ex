defmodule HTTPact do
  @moduledoc """
  An HTTP Contract used to decouple REST API Wrapper libraries from HTTP Client implementations.
  """

  def execute(%HTTPact.Request{http_client: client} = request) do
    client.execute(request)
  end
end
