# Mati

[![CircleCI](https://circleci.com/gh/Maikon/Periscope/tree/master.svg?style=svg&circle-token=59e949fea2dc4490733acf76160f25aa3aad1646)](https://circleci.com/gh/Maikon/Periscope/tree/master)

A command line utility that provides a detailed and quick overview of your
project. The goal is to indicate the main components of the app but also to
indicate possible problematic areas.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `mati` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mati, "~> 0.1.0"}]
    end
    ```

  2. Ensure `mati` is started before your application:

    ```elixir
    def application do
      [applications: [:mati]]
    end
    ```

