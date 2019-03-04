# HTTPact

**Experimental** tool for decoupling API Wrapper libraries from the HTTP Client such as Hackney, IBrowse, or Mint.

The idea is that API Wrapper libraries can depend on HTTPact instead of an implementation detail like an HTTP Client. This way someone using a client library can use the same HTTP Client for all their integrations and consolidate dependencies in their apps. Or if the library requires, a custom pooling strategy built on top of Mint could just follow the HTTPact contract to be used per-request. In fact since the HTTP Client is passed in and invoked per-request there's no reason a custom HTTP Client couldn't be dynamically generated for a given request.

Initially [based on this neat gist from Michal Muskala](https://gist.github.com/michalmuskala/5cee518b918aa5a441e757efca965d22).

## Example Usage

The way I like building REST API Wrappers is with a struct for each command that can be executed against the API service. A valid command struct is a valid request against the service. The functions to create this `command struct` validate and cast parameters into the correct shape and return errors if necessary at the boundary. Valid commands can then be converted into a `%Request{}` which contains a client implementation that conforms to the `HTTPact.Client` behaviour. We can inject this `Client` at run-time on a per-request basis rather than compile, build, or application start time. A `%Response{}` is returned from the client implementation which can then be handled by the Wrapper library and converted into a domain entity. This domain entity can be converted back into a generic map where the consumer of the Wrapper library can do what it pleases.

```elixir
defmodule MyAPIWrapper do
  alias MyAPIWrapper.{CreateUser, User}

  def create_user(params) when is_map(params) do
    with {:ok, command} <- CreateUser.new(params) do
      command
      |> CreateUser.to_request()
      |> HTTPact.execute()
      |> User.from_request()
      |> Map.from_struct()
    end
  end

  defmodule MyAPIWrapper.CreateUser do
    defstruct [:name, :email]

    def new(%{name: name, email: email}) do
      {:ok, %__MODULE__{
        name: name,
        email: email,
      }}
    end
    def new(_), do: {:error, "invalid CreateUser params"}

    def to_request(%__MODULE__{name: name, email: email}) do
      %HTTPact.Request{
        method: :post,
        path: "https://www.myapiservice.example/v1/users",
        headers: [
          {"Content-Type", "application/x-www-form-urlencoded"},
          {"Authorization", "Bearer #{MyAPIWrapper.Auth.fetch_token()}"},
        ],
        body: URI.encode_query(%{
          "name" => name,
          "email" => email,
        }),
        http_client: Application.get_env(:my_api_wrapper, :http_client)
      }
    end
  end

  defmodule MyAPIWrapper.User do
    defstruct [:id, :name, :email]

    def from_response(%HTTPact.Response{status: 200, body: body}) do
      with {:ok, %{
        "id" => id, "email" => email, "name" => name
      }} <- Jason.decode(body) do
        %__MODULE___{
          id: id,
          email: email,
          name: name,
        }
      end
    end
  end

end

```

### Notes

* **This is a proof of concept and not recommended for production**
* Still not sure about interfaces for: Streaming, Multi-part Request Handling, HTTP2, Websockets, and HTTPS
* We would still need some validation and error handling to surface issues with invalid HTTP Clients
  * Further compile-time validation of a client implementation could be done with a `use` macro; although would like to avoid Macros unless necessary
* Authentication can implemented when building the `%Request{}` by setting headers
* A useful feature of HTTPact would be a TestClient utility that can build a client mock to return a `%Request{}` depending on passed in parameters.
  * Maybe also utilities to setup a web server that behaves similarly so the HTTPClient implementation can be tested, although that's further from the scope of HTTPact.
* Generators and protocols could help to enforce the `to_request` and `from_response` aspects of building the API Wrapper library.

Instead of API Wrapper libraries requiring usage of a specific HTTP Client implementation, the user can decide what works best for their use-case. Widespread usage of an HTTP contract like this could significantly improve maintainability of these kinds of API Wrapper libraries.

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

