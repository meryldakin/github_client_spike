defmodule Git do

  @repo_path "temp"

  def clone(remote) do
    path = create_timestamp
    |> create_path

    command(["clone", remote, path], fn _ -> %Git.Repo{path: path, remote: remote} end)
  end

  def command(cli_args, callback) do
    output = System.cmd("git", cli_args)
    callback.(output)
  end

  def command(cli_args, options, callback) do
    output = System.cmd("git", cli_args, options)
    callback.(output)
  end

  def create_timestamp do
    DateTime.utc_now
    |> DateTime.to_string
    |> String.split(" ")
    |> Enum.join("-")
  end

  def create_path(timestamp) do
    "#{@repo_path}/#{timestamp}"
  end

  def rm_origin(repo) do
    command(["remote", "rm", "origin"], [cd: repo.path], fn _-> %Git.Repo{repo | remote: nil } end)
  end




  def test do
    clone("git@github.com:alexgriff/hidden_phrase_frontend.git")
    |> rm_origin
  end
end
