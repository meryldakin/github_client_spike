defmodule GithubClientSpike do
  # alias Geef.Repository
  # alias Geef.Reference
  # alias Geef.Commit
  # alias Geef.Tree
  # alias Geef.Oid
  # alias Geef.Object
  # alias Geef.Signature
  # sig = Signature.now("alexgriff", "alexalexgriffith@gmail.com")
  # repo = Repository.open!("./temp/2018-08-09-19\:15\:15.696576Z")
  # {_, commit} = Geef.Commit.lookup(repo, Oid.parse("3a0d892c7ad919f269d15a80477241e19342c951"))
  # tree_id = Commit.tree_id(commit)
  # {_, tree} = Tree.lookup(repo, tree_id)

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
    |> team_id(%{org_name: org_name, team_name: team_name})
  end

  def team_id(%{"id" => id}, %{org_name: _, team_name: _}), do: id

  def team_id(_, %{org_name: org_name, team_name: team_name}) do
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

  def clone do
    now = DateTime.utc_now
    |> DateTime.to_string
    |> String.split(" ")
    |> Enum.join("-")

    System.cmd("git", ["clone", "git@github.com:alexgriff/hidden_phrase_frontend.git", "temp/#{now}"])
  end


end
