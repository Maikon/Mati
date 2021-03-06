defmodule Mati.BuildFileListTest do
  use ExUnit.Case
  alias Mati.BuildFileList

  setup do
    directory_1 = "test/example_dir"
    directory_2 = directory_1 <> "/nested_dir"
    file_1 = Path.absname(directory_1 <> "/" <> "file_1.txt")
    file_2 = Path.absname(directory_2 <> "/" <> "file_2.txt")

    File.mkdir(directory_1)
    File.touch(file_1)
    File.mkdir(directory_2)
    File.touch(file_2)

    on_exit fn ->
      File.rm(file_2)
      File.rm(file_1)
      File.rmdir(directory_2)
      File.rmdir(directory_1)
    end

    {:ok, %{dir_1: directory_1, file_1: file_1, file_2: file_2}}
  end

  describe "building a list of files" do
    test "recursively adds regular files", %{dir_1: d1, file_1: f1, file_2: f2} do
      assert BuildFileList.execute(d1) == [f1, f2]
    end

    test "directories can be ignored from the final list", %{dir_1: d1, file_1: f1} do
      assert BuildFileList.execute(d1, ["nested_dir"]) == [f1]
    end

    test "files with certain extensions can be ignored from the final list", %{dir_1: d1, file_1: f1, file_2: f2} do
      result = BuildFileList.execute(d1, [], ".txt")

      refute Enum.member?(result, f1)
      refute Enum.member?(result, f2)
    end
  end
end
