defmodule Mati.ArgumentsParserTest do
  use ExUnit.Case
  alias Mati.ArgumentsParser

  setup do
    gitignore = Path.absname("test/.gitignore")
    File.touch(gitignore)

    {:ok, file} = File.open(gitignore, [:write])
    IO.binwrite(file, """
    # some comment
    directory_1/
    /directory_2
    # another comment
    example_file.txt
    """
    )

    on_exit fn ->
      File.rm(gitignore)
    end

    {:ok, %{gitignore: gitignore}}
  end

  describe "extracting the target directory" do
    test "returns the target directory to be used for analysis" do
      args = [target: "target_dir"]

      result = ArgumentsParser.extract_directory(args)

      assert result == "target_dir"
    end

    test "returns empty if one is not provided" do
      args = [invalid: "input"]

      result = ArgumentsParser.extract_directory(args)

      assert result == ""
    end
  end

  describe "extracting file contents from .gitignore" do
    test "strips out leading slash from the beginning of the directories", %{gitignore: gitignore} do
      result = ArgumentsParser.extract_ignored_files(gitignore)

      assert Enum.member?(result, "directory_2")
      refute Enum.member?(result, "/directory_2")
    end

    test "returns the directories and files", %{gitignore: gitignore} do
      result = ArgumentsParser.extract_ignored_files(gitignore)

      assert result == ["directory_1/", "directory_2", "example_file.txt"]
    end
  end

  describe "extracting file extensions from command line arguments" do
    test "returns file extensions that should be ignored" do
      args = [ignore: "jpg,txt,png"]

      result = ArgumentsParser.extract_ignored_patterns(args)

      assert result == ["jpg", "txt", "png"]
    end

    test "returns an empty list if none is provided" do
      args = []

      result = ArgumentsParser.extract_ignored_patterns(args)

      assert result == []
    end
  end

  describe "extracting number of files to show" do
    test "returns the number when the flag is present" do
      args = [files: "20"]

      result = ArgumentsParser.extract_number_of_files(args)

      assert result == 20
    end

    test "returns a default when the flag is not present" do
      args = []

      result = ArgumentsParser.extract_number_of_files(args)

      assert result == 10
    end

    test "can return all" do
      args = [files: "all"]

      result = ArgumentsParser.extract_number_of_files(args)

      assert result == :all
    end
  end
end
