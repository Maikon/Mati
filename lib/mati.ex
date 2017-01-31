defmodule Mati do
  alias Mati.Screen

  def main(args) do
    OptionParser.parse(args) |> print_table
  end

  defp print_table({[help: true], _remaining, _invalid}) do
    IO.puts """
    Usage:

    1. mati --target lib

    2. mati --target lib --ignore png,jpg,txt

    3. mati --target lib --files 20

    4. mati --files all

    5. mati --target test --ignore png,jpg --files all
    """
  end

  defp print_table({valid_args, _remaining, _invalid}) do
    Screen.display_table(valid_args)
    |> IO.puts
  end
end
