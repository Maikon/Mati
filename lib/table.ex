defmodule Mati.Table do
  alias IO.ANSI
  require Integer
  @default_max_width 15

  def build_table(files) do
    longest_filename = longest_filename(files)
    {header_size, header_with_separator} = build_header(longest_filename)

    Enum.reduce(files, [header_with_separator], fn(file, table) ->
      table ++ construct_line_from_file(file, longest_filename, header_size)
    end)
  end

  defp construct_line_from_file(file, longest_filename, header_size) do
    [
      build_file_column(clean_filename(file.name), longest_filename)
      <> "|"
      <> build_column(to_string(file.line_count))
      <> "|"
      <> build_column(to_string(file.commits))
      <> "|"
      <> build_column(DateTime.to_string(file.datetime))
      <> "\n"
      <> yellow(replicate("-", header_size))
      <> "\n"
    ]
  end

  defp longest_filename([]), do: @default_max_width
  defp longest_filename(files) do
    Enum.max_by(files, fn(file) ->
      String.length(file.name)
    end).name
    |> String.length
  end

  defp build_header(longest_filename) do
    header = header(longest_filename)

    header_size = String.length(header) - String.length(cyan("")) * 3 - 3
    header_with_separator = yellow(replicate("=", header_size))
    <> "\n"
    <> header
    <> "\n"
    <> yellow(replicate("=", header_size))
    <> "\n"

    {header_size, header_with_separator}
  end

  defp header(longest_filename) do
    cyan(build_column("File", longest_filename))
    <> "|"
    <> cyan(build_column("Line Count"))
    <> "|"
    <> cyan(build_column("Commits"))
    <> "|"
    <> cyan(build_column("Last Modified"))
  end

  defp clean_filename(filename) do
    String.split(filename, "./") |> to_string
  end

  defp build_file_column(column_value, max_width) do
    {padding, extra_padding} = padding(column_value, max_width)

    column_value
    <> replicate(" ", extra_padding + padding * 2)
  end

  defp build_column(column_value, max_width \\ @default_max_width) do
    {padding, extra_padding} = padding(column_value, max_width)

    replicate(" ", padding)
    <> column_value
    <> replicate(" ", padding + extra_padding)
  end

  defp padding(column_value, max_width) do
    remaining_space = max_width - String.length(column_value)
    padding = div(remaining_space, 2)
    extra_padding = rem(remaining_space, 2)

    {padding, extra_padding}
  end

  defp replicate(symbol, count) when count < 0, do: String.duplicate(symbol, 1)
  defp replicate(symbol, count), do: String.duplicate(symbol, count)

  defp cyan(str), do: colourize(ANSI.cyan, str)
  defp yellow(str), do: colourize(ANSI.yellow, str)

  defp colourize(color, message) do
    Enum.join([color, message, ANSI.reset], "")
  end
end
