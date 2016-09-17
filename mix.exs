defmodule Mati.Mixfile do
  use Mix.Project

  def project do
    [app: :mati,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:junit_formatter, "~> 1.1.0", only: :test},
    ]
  end
end
