defmodule HTTPactTest do
  use ExUnit.Case
  doctest HTTPact

  test "greets the world" do
    assert HTTPact.hello() == :world
  end
end
