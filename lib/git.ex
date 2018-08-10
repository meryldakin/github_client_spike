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

  def create_timestamp do
    DateTime.utc_now
    |> DateTime.to_string
    |> String.split(" ")
    |> Enum.join("-")
  end

  def create_path(timestamp) do
    "#{@repo_path}/#{timestamp}"
  end

  def cd(repo) do
    x = System.cmd("cd", [repo.path, "&&", "git", "remote", "-v"])
    IO.puts("PATTHHHHHHHH")
    IO.puts(repo.path)
    IO.puts("IN CD")
    IO.inspect(x)
  end

  def rm_origin(repo) do
    cd(repo)
    x = System.cmd("pwd", [])
    IO.puts("IN RM_ORIGIN")
    IO.inspect(x)
    z = System.cmd("git", ["remote", "-v"])
    IO.inspect(z)
  end


  def test do
    clone("git@github.com:alexgriff/hidden_phrase_frontend.git")
    |> rm_origin
  end
end
