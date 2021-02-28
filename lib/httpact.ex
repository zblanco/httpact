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
    with {:ok, response} <- client.(request) do
      Entity.from_response(request, response)
    else
      {:error, _msg} = error -> error
      :error -> {:error, "An unknown error occurred with the given HTTPact client"}
    end
  end

  def execute(%Request{} = request, client) when is_atom(client) do
    with {:ok, response} <- client.execute(request) do
      Entity.from_response(request, response)
    else
      {:error, _msg} = error -> error
      :error -> {:error, "An unknown error occurred with the client: #{Atom.to_string(client)}"}
    end
  end

  def execute(command, client) do
    response =
      Command.to_request(command)
      |> execute(client)

    Entity.from_response(command, response)
  end
end
