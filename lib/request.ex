defmodule HTTPact.Request do
  @moduledoc """
  A generic HTTP request that can be executed by an HTTP Client.
  """
  defstruct [
    :method,
    :path,
    :params,
    :body,
    :http_client,
    options: [],
    headers: [],
  ]

  @type method ::
    :get
    | :post
    | :put
    | :patch
    | :delete
    | :option
    | :head

  @type path() :: String.t()
  @type params() :: %{optional(String.t()) => String.t()}
  @type headers() :: [{header_name :: String.t(), header_value :: String.t()}]
  @typedoc """
  A Module or Function that knows how to use a `Request`.
  """
  @type http_client() :: module() | function()

  @type t() :: %__MODULE__{
    method: method(),
    path: path(),
    params: params(),
    body: any(),
    headers: headers(),
    http_client: http_client(),
    options: Keyword.t()
  }

end

