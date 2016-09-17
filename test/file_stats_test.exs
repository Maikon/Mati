defmodule FileStatsTest do
  use ExUnit.Case
  alias Mati.FileStats

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
