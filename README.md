# HTTPact

Experimental REST API Client Builder library designed to decouple client libraries from the HTTP Client Adapter such as Hackney, IBrowse, or Mint.

The goal and idea being for library authors to depend on HTTPact instead of an implementation detail like an HTTP adapter. This way someone using a client library can use the same HTTP adapter for all their integrations and consolidating dependencies in their apps.

Initially [based on this neat gist](https://gist.github.com/michalmuskala/5cee518b918aa5a441e757efca965d22).

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

