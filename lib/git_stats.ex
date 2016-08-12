defmodule Periscope.GitStats do

  def commits_for_file(file) do
    file
    |> git_log
    |> extract_commits
  end

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
