defmodule DisplayTest do
  use ExUnit.Case
  alias Mati.Display
  alias Mati.FileStats

  test "builds the table for a list of files" do
    file_1 = %FileStats{name: "file_1", line_count: 10, commits: 10}
    file_2 = %FileStats{name: "file_2", line_count: 12, commits: 12}
    files = [file_1, file_2]

    result = Display.build_table(files)

    assert result =~ "file_1"
    assert result =~ "10"
    assert result =~ "10"
    assert result =~ "file_2"
    assert result =~ "12"
    assert result =~ "12"
  end

  test "table includes a default header" do
    file = %FileStats{name: "file", line_count: 0, commits: 0}

    result = Display.build_table([file])

    assert result =~ "File"
    assert result =~ "Line Count"
    assert result =~ "Commits"
  end

  test "the table columns have default width" do
    file_1 = %FileStats{name: "file", line_count: 0, commits: 0}
    files = [file_1]

    result = Display.build_table(files)

    assert result =~ "file   |       0       |       0"
  end

  test "the name of the file is cleaned if its at the top level directory" do
    file_1 = %FileStats{name: "./file", line_count: 0, commits: 0}
    files = [file_1]

    result = Display.build_table(files)

    refute result =~ "./"
  end
end
