defmodule Mati.BuildFileList do

  def execute(directory, ignored_files \\ [], ignored_extensions \\ []) do
    find_regular_files([directory], [], ignored_files, ignored_extensions)
  end

  def find_regular_files([], reg_files, _ignored_files, _ignored_extensions), do: reg_files
  def find_regular_files([file | rest], reg_files, ignored_files, ignored_extensions) do
    absolute_path = Path.absname(file)

    if File.dir?(absolute_path) do
      {:ok, files} = File.ls(absolute_path)

      fully_qualified_files = files
      |> reject_ignored_files(ignored_files)
      |> reject_ignored_extensions(ignored_extensions)
      |> qualify_file_with_path(absolute_path)

      find_regular_files(rest ++ fully_qualified_files, reg_files, ignored_files, ignored_extensions)
    else
      find_regular_files(rest, reg_files ++ [file], ignored_files, ignored_extensions)
    end
  end

  defp reject_ignored_files(files, ignored_files) do
    Stream.reject(files, fn(file) ->
      Enum.member?(ignored_files, file)
    end)
  end

  defp reject_ignored_extensions(files, ignored_extensions) do
    Stream.reject(files, fn(file) ->
      String.contains?(file, ignored_extensions)
    end)
  end

  defp qualify_file_with_path(files, path) do
    Enum.map(files, fn(file) ->
      path <> "/" <> file
    end)
  end
end
