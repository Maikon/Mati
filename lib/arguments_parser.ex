defmodule Mati.ArgumentsParser do
  @home_dir "."
  @no_extensions []
  @default_number_of_files 10

  def extract_directory(args) do
    Keyword.fetch(args, :target)
    |> extract_dir
  end

  def extract_ignored_files(gitignore) do
    {:ok, contents} = File.read(gitignore)

    contents
    |> String.split("\n")
    |> Enum.reject(&comments_and_empty_lines/1)
    |> Enum.map(&remove_leading_slash/1)
  end

  def extract_number_of_files(args) do
    Keyword.fetch(args, :files)
    |> extract_number
  end

  def extract_ignored_patterns(args) do
    Keyword.fetch(args, :ignore)
    |> extract_extensions
  end

  defp extract_number({:ok, "all"}), do: :all
  defp extract_number({:ok, true}), do: @default_number_of_files
  defp extract_number({:ok, num}), do: String.to_integer(num)
  defp extract_number(:error), do: @default_number_of_files

  defp extract_dir({:ok, true}), do: @home_dir
  defp extract_dir({:ok, ""}), do: @home_dir
  defp extract_dir(:error), do: @home_dir
  defp extract_dir({:ok, dir}), do: dir

  defp extract_extensions({:ok, true}), do: @no_extensions
  defp extract_extensions({:ok, ""}), do: @no_extensions
  defp extract_extensions(:error), do: @no_extensions
  defp extract_extensions({:ok, extensions}), do: String.split(extensions, ",")

  defp remove_leading_slash(file) do
    String.replace_leading(file, "/", "")
  end

  defp comments_and_empty_lines(file) do
    String.starts_with?(file, "#") || String.length(file) == 0
  end
end
