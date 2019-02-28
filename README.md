# HTTPact

**Experimental** REST API Wrapper tool for decoupling client libraries from the HTTP Client such as Hackney, IBrowse, or Mint.

The idea is that API Wrapper libraries can depend on HTTPact instead of an implementation detail like an HTTP Client. This way someone using a client library can use the same HTTP adapter for all their integrations and consolidating dependencies in their apps. Or if the library requires, a custom pooling strategy built on top of Mint could also just follow the HTTPact contract to be used per-request.

Initially [based on this neat gist from Michal Muskala](https://gist.github.com/michalmuskala/5cee518b918aa5a441e757efca965d22).

### Notes

* **This is a proof of concept and not recommended for production**
* Still not sure about interfaces for: Streaming, Multi-part Request Handling, HTTP2, Websockets, and HTTPS
* We would still need some validation and error handling
* Authentication would implemented when building the `%Request{}`
* Further compile-time validation of a client implementation could be done with a `use` macro

The way I like building REST API Wrappers is with a struct for each command that can be executed against the API service. The functions to create this `command struct` validate and cast parameters into the correct shape and return errors if necessary. Valid commands can then be converted into a `%Request{}` which contain an HTTPClient implementation that conforms to the `HTTPact.Client` behaviour. We can inject this `Client` at run-time on a per-request basis rather than compile, build, application start time. A `%Response{}` is returned from the client implementation which can then be handled by the Wrapper library and converted into a domain entity. This domain entity can be converted back into a generic map where the consumer of the Wrapper library can do what it pleases.

We can easily mock our HTTP Client Adapter with a module/function that gives us an expected response for tests. 

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

