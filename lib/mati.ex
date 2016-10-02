defmodule Mati do
  @gitignore Path.absname(".gitignore")

  alias Mati.BuildFileList
  alias Mati.FileStats
  alias Mati.Display
  alias Mati.ArgumentsParser

  def main(args) do
    {parsed_args, _remaining, _invalid} = OptionParser.parse(args)

    directory = ArgumentsParser.extract_directory(parsed_args)
    ignored_files = ArgumentsParser.extract_ignored_files(@gitignore)
    ignored_patterns = ArgumentsParser.extract_ignored_patterns(parsed_args)

    print_all_files({directory, ignored_files ++ [".git"], ignored_patterns})
  end

  defp print_all_files({"", _ignored_files, _ignored_patterns}) do
    IO.puts """
    Please provide a directory to analyse. Examples:

    1. mati --target .

    2. mati --target lib --ignore png,jpg,txt
    """
  end

  defp print_all_files({directory, ignored_files, ignored_patterns}) do
    BuildFileList.execute(directory, ignored_files, ignored_patterns)
    |> FileStats.convert_from_regular_files
    |> FileStats.sort_by_churn
    |> Display.build_table
    |> IO.puts
  end
end
