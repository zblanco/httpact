defmodule HTTPact do
  @moduledoc """
  An HTTP Contract used to decouple REST Api client libraries from Adapters.
  """

  def execute(%HTTPact.Request{http_client: client} = request) do
    client.execute(request)
  end
end
