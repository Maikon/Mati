defmodule FileStatsTest do
  use ExUnit.Case
  alias Mati.FileStats

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

    transformed = FileStats.convert_from_regular_files(files)
    transformed_file = List.first(transformed)

    assert transformed_file.name
    assert transformed_file.commits
    assert transformed_file.line_count
  end

  test "file name is relative to the current working directory", %{file_1: file_1} do
    files = [file_1]

    transformed = FileStats.convert_from_regular_files(files)
    transformed_file = List.first(transformed)

    assert transformed_file.name == "file_1.txt"
  end

  test "can provide the line count for a given file" do
    assert FileStats.line_count("test/test_file.txt") == 4
  end

  test "provides the commit count for a given file" do
    commits = FileStats.file_commits("test/test_file.txt")

    assert 2 = length(commits)
    assert "commit" <> _sha = List.first(commits)
    assert "commit" <> _sha = List.last(commits)
  end
end
