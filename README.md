# HTTPact

A contract for HTTP API Wrappers.

The idea is that API Wrapper libraries can depend on HTTPact instead directly on an HTTP Client library.

HTTPact describes how an HTTP Client must accept requests and return responses. 

The `Command` and `Entity` HTTPact defines allow an API Wrapper a clear interface for converting to and from requests and responses.

Initially [based on this neat gist from Michal Muskala](https://gist.github.com/michalmuskala/5cee518b918aa5a441e757efca965d22).

## Example Usage

The way I've trended towards building REST API Wrappers is with a struct for each command that can be executed against the API service. A valid command struct is a valid request against the service. The functions to create this `command struct` validate and cast parameters into the correct shape and return errors if necessary at the boundary. Valid commands can then be converted into a `%Request{}` which contains a client implementation that conforms to the `HTTPact.Client` behaviour. We can inject this `Client` at run-time on a per-request basis rather than compile, build, or application start time. A `%Response{}` is returned from the client implementation which can then be handled by the Wrapper library and converted into a domain entity. This domain entity can be converted back into a generic map where the consumer of the Wrapper library can do what it pleases.

HTTPact lets you implement protocols to control the transformation of a Request or Response into another type
before returning to a consumer.

```elixir
defmodule MyAPIWrapper do
  alias MyAPIWrapper.{CreateUser, User}

  def create_user(params) when is_map(params) do
    with {:ok, command} <- CreateUser.new(params) do
      HTTPact.execute(command, http_client())
    end
  end

  # fetch your http_client at runtime
  defp http_client() do
    Application.get_env(:my_api_wrapper, :http_client)
  end

  defmodule MyAPIWrapper.CreateUser do
    defstruct [:name, :email]

    def new(%{name: name, email: email}) do
      {:ok,
       %__MODULE__{
         name: name,
         email: email
       }}
    end

    def new(_), do: {:error, "invalid CreateUser params"}

    defimpl HTTPact.Command do
      def to_request(%__MODULE__{name: name, email: email}) do
        %HTTPact.Request{
          method: :post,
          path: "https://www.myapiservice.example/v1/users",
          headers: [
            {"Content-Type", "application/x-www-form-urlencoded"},
            {"Authorization", "Bearer #{MyAPIWrapper.Auth.fetch_token()}"}
          ],
          body:
            URI.encode_query(%{
              "name" => name,
              "email" => email
            })
        }
      end
    end
  end

  defmodule MyAPIWrapper.User do
    defstruct [:id, :name, :email]

    defimpl HTTPact.Entity do
      def from_response(%HTTPact.Response{status: 200, body: body}) do
        with {:ok,
              %{
                "id" => id,
                "email" => email,
                "name" => name
              }} <- Jason.decode(body) do
          %User{
            id: id,
            email: email,
            name: name
          }
        end
      end
    end
  end
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `httpact` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:httpact, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/httpact](https://hexdocs.pm/httpact).

