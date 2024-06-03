defmodule ElixirAuthMicrosoft.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_auth_microsoft,
      version: "1.3.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description: "Turnkey Microsoft OAuth for Elixir/Phoenix App.",
      # Coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        t: :test
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
      {:httpoison, ">= 0.6.1"},
      {:jason, ">= 1.0.0"},

      # Testing
      {:excoveralls, "~> 0.18.0", only: [:test, :dev]},
      {:mock, "~> 0.3.7", only: :test},

      # For publishing Hex.docs:
      {:ex_doc, "~> 0.34.0", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      t: ["test"],
      c: ["coveralls.html"]
    ]
  end

  # Package used for publishing on Hex.pm see: https://hex.pm/docs/publish
  defp package() do
    [
      files:
        ~w(lib/elixir_auth_microsoft.ex lib/httpoison_mock.ex LICENSE mix.exs README.md),
      name: "elixir_auth_microsoft",
      licenses: ["GPL-2.0-or-later"],
      maintainers: ["dwyl"],
      links: %{"GitHub" => "https://github.com/dwyl/elixir-auth-microsoft"}
    ]
  end
end
