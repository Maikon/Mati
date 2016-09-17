defmodule Mati.ConvertFilesToFileStats do
  alias Mati.FileStats

  def convert(files) do
    Enum.map(files, fn(file) ->
      %FileStats{name: name(file),
                 commits: commits(file),
                 line_count: lines(file)}
    end)
  end

  defp name(file),    do: file |> Path.relative_to_cwd
  defp commits(file), do: file |> FileStats.file_commits |> length
  defp lines(file),   do: file |> FileStats.line_count
end
