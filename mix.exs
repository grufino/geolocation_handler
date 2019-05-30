defmodule GeolocationHandler.MixProject do
  use Mix.Project

  def project do
    [
      app: :geolocation_handler,
      version: "0.1.0",
      elixir: "~> 1.8",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Geolocation Handler",
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # ...

  # Ensures `test/support/*.ex` files are read during tests
  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Library dedicated to parse and persist CSV files with geolocation data in a specific format."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README", "LICENSE*"],
      maintainers: ["Gabriel Rufino"],
      licenses: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:csv, "~> 2.3"},
      {:timex, "~> 3.1"}
    ]
  end
end
