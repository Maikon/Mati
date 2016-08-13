defmodule Periscope.FileStats do

  def line_count(file) do
    {:ok, contents} = File.read(file)
    contents
    |> String.split("\n")
    |> length
  end
end
