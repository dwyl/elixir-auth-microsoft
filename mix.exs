defmodule ElixirAuthMicrosoft.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_auth_microsoft,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8.0"},
      {:jason, "~> 1.2"},

      # Testing
      {:excoveralls, "~> 0.15.0", only: [:test, :dev]},
      {:mock, "~> 0.3.7", only: :test},
    ]
  end
end
