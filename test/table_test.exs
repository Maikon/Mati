defmodule TableTest do
  use ExUnit.Case
  alias Mati.Table
  alias Mati.FileStats

  test "table includes a header with titles" do
    result = Table.build_table([]) |> extract_line_at_position(0)

    assert result =~ "File"
    assert result =~ "Line Count"
    assert result =~ "Commits"
  end

  test "table gets build from a list of files" do
    file_1 = build_filestat("file_1", 10, 10)
    file_2 = build_filestat("file_2", 12, 12)
    files = [file_1, file_2]

    result = Table.build_table(files)
    file_1_line = extract_line_at_position(result, 1)
    file_2_line = extract_line_at_position(result, 2)

    assert file_1_line =~ "file_1"
    assert file_1_line =~ "10"
    assert file_1_line =~ "10"
    assert file_2_line =~ "file_2"
    assert file_2_line =~ "12"
    assert file_2_line =~ "12"
  end

  test "the lines from the generated table have the same length" do
    file_1 = build_filestat("file_1", 10, 10)
    file_2 = build_filestat("file_2", 12, 12)
    files = [file_1, file_2]

    result = Table.build_table(files)
    file_1_line = extract_line_at_position(result, 1)
    file_2_line = extract_line_at_position(result, 2)

    assert String.length(file_1_line) == String.length(file_2_line)
  end

  test "the table columns display all the values" do
    datetime = DateTime.utc_now
    file_1 = build_filestat("file", 1, 2, datetime)
    files = [file_1]

    result = Table.build_table(files) |> extract_line_at_position(1)

    assert result =~ "file"
    assert result =~ "1"
    assert result =~ "2"
    assert result =~ DateTime.to_string(datetime)
  end

  test "the name of the file is cleaned if its at the top level directory" do
    file_1 = build_filestat("./file", 0, 0)
    files = [file_1]

    result = Table.build_table(files) |> extract_line_at_position(1)

    refute result =~ "./"
  end

  defp build_filestat(name, line_count, commits, datetime \\ DateTime.utc_now) do
    %FileStats{
      name: name,
      line_count: line_count,
      commits: commits,
      datetime: datetime
    }
  end

  defp extract_line_at_position(lines, position) do
    Enum.at(lines, position)
  end
end
