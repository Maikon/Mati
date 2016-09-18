defmodule Mati.FileStats do
  defstruct name: "", commits: 0, line_count: 0

  def convert_from_regular_files(files) do
    Enum.map(files, fn(file) ->
      %Mati.FileStats{name: name(file),
                      commits: commits(file),
                      line_count: lines(file)}
    end)
  end

  def line_count(file) do
    {:ok, contents} = File.read(file)
    contents
    |> String.split("\n")
    |> length
  end

  def file_commits(file) do
    file
    |> git_log
    |> extract_commits
  end

  defp name(file),    do: file |> Path.relative_to_cwd
  defp commits(file), do: file |> file_commits |> length
  defp lines(file),   do: file |> line_count

  defp git_log(file) do
    {command_response, _exit_code} = System.cmd("git", ["log", "--follow", file])
    command_response
  end

  defp extract_commits(raw_response) do
    raw_response
    |> String.split("\n")
    |> Enum.filter(&line_includes_commit_sha?/1)
  end

  defp line_includes_commit_sha?(line) do
    String.starts_with?(line, "commit")
  end
end
