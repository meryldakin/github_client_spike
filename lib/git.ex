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

  def repo_command(repo, cli_args, repo_attributes \\ %{}) do
    command(cli_args, cd(repo), fn _-> repo_callback(repo, repo_attributes) end)
  end

  defp create_timestamp do
    DateTime.utc_now
    |> DateTime.to_string
    |> String.split(" ")
    |> Enum.join("-")
  end

  def create_path(timestamp) do
    "#{@repo_path}/#{timestamp}"
  end

  def rm_origin(repo) do
    repo_command(repo, ["remote", "rm", "origin"], %{remote: nil})
  end

  def add_origin(repo, remote) do
    repo_command(repo, ["remote", "add", "origin", remote], %{remote: remote})
  end

  def push(repo, args \\ []) do
    repo_command(repo, ["push"] ++ args)
  end

  defp append_dot_learn_data(repo, lesson) do
    case File.open("#{repo.path}/.learn", [:append]) do
      {:ok, file} ->
        IO.binwrite(file, dot_learn_property(lesson))
        File.close(file)
      {:error, error} ->
        IO.puts("Argh error")
    end
    repo
  end

  def dot_learn_property(lesson) do
    "\nlesson_uuid: #{lesson}"
  end

  def add(repo) do
    repo_command(repo, ["add", ".learn"])
  end

  def cd(repo) do
    [cd: repo.path]
  end

  def commit(repo, message) do
    repo_command(repo, ["commit", "-m", message])
  end

  def repo_callback(repo, props) do
    Map.merge(repo, props)
  end

  def test do
    clone("git@github.com:alexgriff/hidden_phrase_frontend.git")
    |> rm_origin
    |> add_origin("git@github.com:johann/beef.git")
    |> push(["-u", "origin", "master", "--force"])
    |> append_dot_learn_data("345")
    |> add
    |> commit("append lesson data to .learn")
    |> push
  end
end
