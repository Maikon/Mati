defmodule Mati.Display do
  alias IO.ANSI
  require Integer
  @default_max_width 15

  def build_table(files) do
    longest_filename = longest_filename_with_padding(files)
    {header_size, header_with_separator} = build_header(longest_filename)

    Enum.reduce(files, [header_with_separator], fn(file, table) ->
      table ++ construct_line_from_file(file, longest_filename, header_size)
    end)
  end

  defp construct_line_from_file(file, longest_filename, header_size) do
    [
      build_column(clean_filename(file.name), longest_filename)
      <> "|"
      <> build_column(to_string(file.line_count))
      <> "|"
      <> build_column(to_string(file.commits))
      <> "\n"
      <> yellow(replicate("-", header_size))
      <> "\n"
    ]
  end

  defp longest_filename_with_padding([]), do: @default_max_width
  defp longest_filename_with_padding(files) do
    extra_padding = 5

    Enum.max_by(files, fn(file) ->
      String.length(file.name)
    end).name
    |> String.length
    |> Kernel.+(extra_padding)
  end

  defp build_header(longest_filename) do
    header =
    cyan(build_column("File", longest_filename))
    <> "|"
    <> cyan(build_column("Line Count"))
    <> "|"
    <> cyan(build_column("Commits"))

    header_size = String.length(header)
    header_with_separator = header <> "\n" <> yellow(replicate("=", header_size)) <> "\n"

    {header_size, header_with_separator}
  end

  defp clean_filename(filename) do
    String.split(filename, "./") |> to_string
  end

  defp build_column(column_value, max_width \\ @default_max_width) do
    padding_to_be_added(column_value, max_width)
    |> construct_column
  end

  defp padding_to_be_added(column_value, max_width) do
    remaining_space = max_width - String.length(column_value)
    padding = div(remaining_space, 2)
    extra_padding = rem(remaining_space, 2)

    {column_value, padding, extra_padding}
  end

  defp construct_column({column_value, padding, extra_padding = 0}) do
    column(column_value, padding, extra_padding)
  end

  defp construct_column({column_value, padding, extra_padding}) do
    column(column_value, padding, extra_padding)
  end

  defp column(column_value, padding, extra_padding) do
    replicate(" ", padding)
    <> column_value
    <> replicate(" ", padding + extra_padding)
  end

  defp replicate(symbol, count), do: String.duplicate(symbol, count)

  defp cyan(str), do: colourize(ANSI.cyan, str)
  defp yellow(str), do: colourize(ANSI.yellow, str)

  defp colourize(color, message) do
    Enum.join([color, message, ANSI.reset], "")
  end
end
