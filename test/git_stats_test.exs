defmodule GitStatsTest do
  use ExUnit.Case
  alias Periscope.GitStats

  test "retrieves the commits for a given file" do
    commits = GitStats.commits_for_file("test/test_file.txt")

    assert 2 = length(commits)
    assert "commit" <> _sha = List.first(commits)
    assert "commit" <> _sha = List.last(commits)
  end
end
