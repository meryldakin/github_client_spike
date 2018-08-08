defmodule GithubClientSpike do
  @moduledoc """
  Documentation for GithubClientSpike.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GithubClientSpike.hello
      :world

  """
  def hello do
    :world
  end

  def client do
    Tentacat.Client.new(%{access_token: access_token}, url)
  end

  # the syntax for passing in the map as the second arg is not quite correct, still
  # working on it
  def find_or_create_team(organization_name, %{
    "description" => "description",
    "name" => "name",
    "privacy" => "privacy",
    "repo_names" => "repo_names"
    } = body) do
    Tentacat.Organizations.Teams.create(client, organization_name, body)
  end

  def access_token do
    # add token here
  end

  def url do
    "https://gh.learn.co/api/v3/"
  end
end
