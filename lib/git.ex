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
    command(["remote", "rm", "origin"], [cd: repo.path], fn _-> %Git.Repo{repo | remote: nil } end)
  end

  def add_origin(repo, remote) do
    command(["remote", "add", "origin", remote], [cd: repo.path], fn _-> %Git.Repo{repo | remote: remote} end)
  end

  # git push -u origin master

  def push(repo) do
    command(["push", "-u", "origin", "master"], [cd: repo.path], fn _-> repo end)
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

  def test do
    clone("git@github.com:alexgriff/hidden_phrase_frontend.git")
    |> rm_origin
    |> add_origin("git@github.com:johann/beef.git")
    |> push
    |> append_dot_learn_data("345")
  end
end
