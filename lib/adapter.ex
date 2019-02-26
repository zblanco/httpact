defmodule HTTPact.Adapter do
  @moduledoc """
  Behaviour an HTTP Client implementation must implement.
  """
  alias HTTPact.{Request, Response}

  @callback execute(Request.t) :: {:ok, Response.t} | {:error, Exception.t}
end
