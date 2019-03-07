defmodule HTTPactTest do
  use ExUnit.Case
  doctest HTTPact
  HTTPact.{Request, Response}

  test "We can mock an HTTP Client with anonymous functions for testing API Wrappers " do
    # Build a function that knows how to return responses from matched requests
    test_client = fn %Request{
      method: :get,
      body: "test body",
      path: "https://testsite.test/tests",
      headers: [{"test", "header"}],
    } ->
      %Response{
        status: 200,
        body: "it's kind of alive!",
        headers: [{"test", "header"}],
      }
    end

    request = %Request{
      method: :get,
      body: "test body",
      path: "https://testsite.test/tests",
      headers: [{"test", "header"}],
      http_client: test_client,
    }

    assert HTTPact.execute(request) == %Response{
      status: 200,
      body: "it's kind of alive!",
      headers: [{"test", "header"}],
    }
  end

  test "We can test an HTTP Client implementation by setting up a simple test server" do
    assert false
  end
end
