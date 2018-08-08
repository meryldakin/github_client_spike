defmodule GithubClientSpikeTest do
  use ExUnit.Case
  doctest GithubClientSpike

  test "greets the world" do
    assert GithubClientSpike.hello() == :world
  end
end
