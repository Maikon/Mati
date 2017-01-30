defmodule Mati.Mixfile do
  use Mix.Project

  def project do
    [app: :mati,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript(),
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
      {:flow, "~> 0.11"}
    ]
  end
end
