defmodule Mati do
  alias Mati.Screen

  def main(args) do
    {parsed_args, _remaining, _invalid} = OptionParser.parse(args)

    case Keyword.fetch(parsed_args, :target) do
      {:ok, _dir} -> print_table(parsed_args)
      :error -> print_table()
    end
  end

  defp print_table() do
    IO.puts """
    Please provide a directory to analyse. Examples:

    1. mati --target .

    2. mati --target lib --ignore png,jpg,txt

    3. mati --target . --files 20

    4. mati --target . --files all
    """
  end

  defp print_table(args) do
    Screen.display_table(args)
    |> IO.puts
  end
end
