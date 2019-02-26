defmodule HTTPact.Request do
  @moduledoc """
  A generic HTTP request that can be executed by an HTTP Adapter.
  """
  defstruct [
    :method,
    :path,
    :params,
    :body,
    :adapter,
    options: [],
    headers: %{},
  ]

  @type method ::
    :get
    | :post
    | :put
    | :patch
    | :delete
    | :option
    | :head

  @type path :: String.t
  @type params :: %{optional(String.t) => String.t}
  @type headers :: %{optional(String.t) => [String.t]}

  @type t(body) :: %__MODULE__{
    method: method,
    path: path,
    params: params,
    body: body,
    headers: headers,
    adapter: HTTP.Adapter.t,
    options: Keyword.t
  }

end

