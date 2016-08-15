defmodule ConvertFilesToFileStatsTest do
  use ExUnit.Case
  alias Periscope.ConvertFilesToFileStats

  setup do
    file_1 = Path.absname("file_1.txt")
    File.touch(file_1)

    on_exit fn ->
      File.rm(file_1)
    end

    {:ok, %{file_1: file_1}}
  end

  test "transforms a list of files into file stats", %{file_1: file_1} do
    files = [file_1]

    transformed = ConvertFilesToFileStats.convert(files)
    transformed_file = List.first(transformed)

    assert transformed_file.name
    assert transformed_file.commits
    assert transformed_file.line_count
  end

  test "file name is relative to the current working directory", %{file_1: file_1} do
    files = [file_1]

    transformed = ConvertFilesToFileStats.convert(files)
    transformed_file = List.first(transformed)

    assert transformed_file.name == "file_1.txt"
  end
end
