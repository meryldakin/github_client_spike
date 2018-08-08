defmodule GithubClientSpike do
  @access_token System.get_env("GHE_TOKEN")
  @url "https://gh.learn.co/api/v3/"
  @client Tentacat.Client.new(%{access_token: @access_token}, @url)

  def client, do: @client

  @doc """
  # https://developer.github.com/enterprise/2.14/v3/orgs/#get-an-organization
  """
  def find_organization(org_name) do
    Tentacat.Organizations.find @client, org_name
  end

  @doc """
  https://developer.github.com/enterprise/2.14/v3/teams/#create-team
  """
  def find_or_create_team(org_name) do
    team_name = "authors"
    {_status, teams, _resp} = Tentacat.Organizations.Teams.list(@client, org_name)

    Enum.find(teams, fn team -> team["name"] == team_name end)
    |> get_team_id(%{org_name: org_name, team_name: team_name})
  end

  def get_team_id(%{"id" => id}, %{org_name: _, team_name: _}), do: id

  def get_team_id(_, %{org_name: org_name, team_name: team_name}) do
    params = %{"name" => team_name, "private" => "closed"}
    {_status, %{"id" => id}, _resp } = Tentacat.Organizations.Teams.create(@client, org_name, params)
    id
  end

  def add_member_to_team(team_id, username, options \\ %{}) do
    Tentacat.Teams.Members.create(client, team_id, username, options)
  end

  def run(username) do
    find_or_create_team("DEV-learn-co-students")
    |> add_member_to_team(username)
  end

end
