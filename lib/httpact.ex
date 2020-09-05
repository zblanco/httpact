defmodule HTTPact do
  @moduledoc """
  An HTTP Contract used to decouple REST API Wrapper libraries from HTTP Client implementations.

  HTTPact provides protocols in the way of `Command` and `Entity` for converting to and from `Request` and `Response` structures.
  """
  alias HTTPact.{
    Command,
    Entity,
    Request,
    Response
  }

  @typedoc """
  A Module that implements the `HTTPact.Client` behaviour or Function that knows how to use a `Request` and return a `Response`.
  """
  @type http_client() :: module() | (%Request{} -> %Response{})

  @typedoc """
  Some data, probably a struct that can be converted into a valid `Request` by invoking the `Command.to_request/1` protocol.
  """
  @type command() :: any()

  @spec execute(Request.t() | command(), http_client()) :: any
  def execute(%Request{} = request, client) when is_function(client) do
    client.(request)
    |>Entity.from_response()
  end
  def execute(%Request{} = request, client) when is_atom(client) do
    client.execute(request)
    |> Entity.from_response()
  end
  def execute(command, client) do
    Command.to_request(command)
    |> execute(client)
    |> Entity.from_response()
  end
end
