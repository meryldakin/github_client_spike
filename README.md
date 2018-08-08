# Create client

client = Tentacat.Client.new(%{access_token: "token"}, "https://gh.learn.co/api/v3/")

# Create team of organization

body = %{
  "description" => "Team for everyone with commit access",
  "name" => "newer team",
  "privacy" => "closed",
  "repo_names" => ["my_org/secret_repo", "my_org/secret_repo2"]
}

Tentacat.Organizations.Teams.create(client, "DEV-learn-co-curriculum", body)
