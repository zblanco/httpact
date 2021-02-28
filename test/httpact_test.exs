defmodule HTTPactTest do
  use ExUnit.Case
  doctest HTTPact
  alias HTTPact.{Request, Response}

  test "We can mock an HTTP Client with anonymous functions for testing API Wrappers" do
    # Build a function that knows how to return responses from matched requests
    test_client = fn %Request{
      method: :get,
      body: "test body",
      path: "https://testsite.test/tests",
      headers: [{"test", "header"}],
    } ->
      {:ok, %Response{
        status: 200,
        body: "it's kind of alive!",
        headers: [{"test", "header"}],
      }}
    end

    request = %Request{
      method: :get,
      body: "test body",
      path: "https://testsite.test/tests",
      headers: [{"test", "header"}],
    }

    assert HTTPact.execute(request, test_client) == {:ok, %Response{
      status: 200,
      body: "it's kind of alive!",
      headers: [{"test", "header"}],
    }}
  end
end
