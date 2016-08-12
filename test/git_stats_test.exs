defmodule GitStatsTest do
  use ExUnit.Case
  alias Periscope.GitStats

  test "returns empty list if file is not tracked" do
    commits = GitStats.commits_for_file("some_file")

    assert commits == []
  end

  test "retrieves the commits for a given file" do
    commits = GitStats.commits_for_file("test/test_file.txt")

    assert 2 = length(commits)
    assert "commit" <> _sha = List.first(commits)
    assert "commit" <> _sha = List.last(commits)
  end
end
