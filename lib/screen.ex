defmodule Mati.Screen do
  @gitignore Path.absname(".gitignore")
  @ignored_files [".git", ".gitignore"]
  @ignored_patterns ["png", "jpg", "jpeg", "svg"]

  alias Mati.BuildFileList
  alias Mati.FileStats
  alias Mati.Table
  alias Mati.ArgumentsParser

  def display_table(args) do
    {directory, ignored_files, ignored_patterns, number_of_files} = extract_args(args)

    build_table(directory, ignored_files, ignored_patterns)
    |> select_amount(number_of_files)
  end

  def select_amount(filestats, :all), do: filestats
  def select_amount(filestats, amount), do: Enum.take(filestats, amount + 1)

  def build_table(directory, ignored_files, ignored_patterns) do
    BuildFileList.execute(directory, ignored_files, ignored_patterns)
    |> FileStats.convert_from_regular_files
    |> FileStats.sort_by_churn
    |> FileStats.sort_by_date
    |> Table.build_table
  end

  defp extract_args(args) do
    directory = ArgumentsParser.extract_directory(args)
    ignored_files = ArgumentsParser.extract_ignored_files(@gitignore)
    ignored_patterns = ArgumentsParser.extract_ignored_patterns(args)
    number_of_files = ArgumentsParser.extract_number_of_files(args)

    {
      directory,
      ignored_files ++ @ignored_files,
      ignored_patterns ++ @ignored_patterns,
      number_of_files
    }
  end
end
