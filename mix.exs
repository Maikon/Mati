defmodule Mati.Mixfile do
  use Mix.Project

  def project do
    [app: :mati,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :gen_stage]]
  end

  def escript do
    [main_module: Mati]
  end

  defp deps do
    [
      {:junit_formatter, "~> 1.1.0", only: :test},
      {:gen_stage, "~> 0.4"}
    ]
  end
end
