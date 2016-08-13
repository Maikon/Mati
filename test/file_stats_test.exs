defmodule FileStatsTest do
  use ExUnit.Case
  alias Periscope.FileStats

  test "can provide the line count of a file" do
    assert FileStats.line_count("test/test_file.txt") == 4
  end
end
