defmodule Periscope.BuildRegularFileList do

  def execute(directory) do
    find_regular_files([directory], [])
  end

  def find_regular_files([], reg_files), do: reg_files
  def find_regular_files([file | rest], reg_files) do
    absolute_path = Path.absname(file)

    if File.dir?(absolute_path) do
      {:ok, files} = File.ls(absolute_path)

      fully_qualified_files = files
      |> Enum.map(fn(file) -> absolute_path <> "/" <> file end)

      find_regular_files(rest ++ fully_qualified_files, reg_files)
    else
      find_regular_files(rest, reg_files ++ [file])
    end
  end
end
