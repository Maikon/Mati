defmodule Mati.ScreenTest do
  use ExUnit.Case
  alias Mati.Screen

  setup do
    File.mkdir("test/example")

    file_1 = Path.absname("test/example/file_1.txt")
    file_2 = Path.absname("test/example/file_2.txt")
    ignored_file = Path.absname("test/example/ignored.txt")

    File.touch(file_1)
    File.touch(file_2)
    File.touch(ignored_file)

    on_exit fn ->
      File.rm(file_1)
      File.rm(file_2)
      File.rm(ignored_file)
      File.rmdir("test/example")
    end
  end

  test "displays all files" do
    args = [target: "test/example", files: "all"]

    result = Screen.display_table(args) |> Enum.join("\n")

    assert result =~ "file_1"
    assert result =~ "file_2"
    assert result =~ "ignored"
  end

  test "displays all files excluding ignored ones" do
    args = [target: "test/example", ignore: "ignored", files: "all"]

    result = Screen.display_table(args) |> Enum.join("\n")

    assert result =~ "file_1"
    assert result =~ "file_2"
    refute result =~ "ignored"
  end
end
