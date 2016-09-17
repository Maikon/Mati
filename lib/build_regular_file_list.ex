defmodule Mati.BuildRegularFileList do

  def execute(directory, ignored_files \\ []) do
    find_regular_files([directory], [], ignored_files)
  end

  def find_regular_files([], reg_files, _ignored_files), do: reg_files
  def find_regular_files([file | rest], reg_files, ignored_files) do
    absolute_path = Path.absname(file)

    if File.dir?(absolute_path) do
      {:ok, files} = File.ls(absolute_path)

      fully_qualified_files = files
      |> reject_ignored_files(ignored_files)
      |> qualify_file_with_path(absolute_path)

      find_regular_files(rest ++ fully_qualified_files, reg_files, ignored_files)
    else
      find_regular_files(rest, reg_files ++ [file], ignored_files)
    end
  end

  defp reject_ignored_files(files, ignored_files) do
    Enum.reject(files, fn(file) ->
      Enum.member?(ignored_files, file)
    end)
  end

  defp qualify_file_with_path(files, path) do
    Enum.map(files, fn(file) ->
      path <> "/" <> file
    end)
  end
end
