defmodule HTTPact.Response do
  @moduledoc """
  A generic Response to an HTTP Request returned by an HTTPact.Client implementation.
  """
  defstruct [
    :status,
    :body,
    headers: [],
  ]

  @type headers() :: [{header_name :: String.t(), header_value :: String.t()}]

  @type t(body) :: %__MODULE__{
    status: 100..999,
    body: body,
    headers: headers,
  }
end
