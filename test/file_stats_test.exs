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
    assert transformed_file.datetime
  end

  test "file name is relative to the current working directory", %{file_1: file_1} do
    files = [file_1]

    transformed = FileStats.convert_from_regular_files(files)
    transformed_file = List.first(transformed)

    assert transformed_file.name == "file_1.txt"
  end

  test "filestat takes the datetime of the last commit" do
    file_1 = Path.absname("test/test_file_2.txt")
    files = [file_1]

    transformed = FileStats.convert_from_regular_files(files)
    transformed_file = List.first(transformed)

    assert transformed_file.datetime.day == 22
    assert transformed_file.datetime.month == 1
    assert transformed_file.datetime.year == 2017
  end

  # this is for files that are ignored through global gitignore
  test "filestat has a default datetime value if file is not tracked with git", %{file_1: file_1} do
    files = [file_1]
    {:ok, default_datetime, _offset} = DateTime.from_iso8601("1970-01-01T00:00:00Z")

    transformed = FileStats.convert_from_regular_files(files)
    transformed_file = List.first(transformed)

    assert transformed_file.datetime == default_datetime
  end

  test "can provide the line count for a given file" do
    assert FileStats.line_count("test/some_test_file.txt") == 4
  end

  test "provides the commit count for a given file" do
    commits = FileStats.file_commits("test/some_test_file.txt")

    assert 1 = length(commits)
    assert "commit" <> _sha = List.first(commits)
  end

  test "sorts the stats based on the combined value of line and commit count" do
    stat_1 = %FileStats{line_count: 1, commits: 2}
    stat_2 = %FileStats{line_count: 2, commits: 2}

    sorted_list = FileStats.sort_by_churn([stat_1, stat_2])

    assert sorted_list == [stat_2, stat_1]
  end

  test "sorts the stats based on the most recently modified" do
    stat_1 = %FileStats{datetime: DateTime.from_iso8601("1970-01-01T00:00:00Z")}
    stat_2 = %FileStats{datetime: DateTime.utc_now}

    sorted_list = FileStats.sort_by_date([stat_1, stat_2])

    assert sorted_list == [stat_2, stat_1]
  end
end
