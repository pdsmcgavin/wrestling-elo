defmodule Wwelo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wwelo,
      version: "0.4.16",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  def application do
    [
      mod: {Wwelo.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :sentry,
        :timber,
        :cachex
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:absinthe, "~> 1.4.16"},
      {:absinthe_plug, "~> 1.4.7"},
      {:cachex, "~> 3.2.0"},
      {:cowboy, "~> 2.6.3"},
      {:credo, "~> 1.1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ecto_enum, "~> 1.3.2"},
      {:ecto_sql, "~> 3.0"},
      {:elixir_mbcs, github: "woxtu/elixir-mbcs", tag: "0.1.3"},
      {:excoveralls, "~> 0.8", only: :test},
      {:floki, "~> 0.23.0"},
      {:gettext, "~> 0.17.0"},
      {:httpoison, "~> 1.6.1"},
      {:math, "~> 0.3.0"},
      {:mbcs, github: "nekova/erlang-mbcs"},
      {:mock, "~> 0.3.2", only: [:test]},
      {:phoenix, "~> 1.4.10"},
      {:phoenix_ecto, "~> 4.0.0"},
      {:phoenix_html, "~> 2.13.3"},
      {:phoenix_live_reload, "~> 1.2.1", only: :dev},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:plug, "~> 1.8.3"},
      {:plug_cowboy, "~> 2.1.0"},
      {:poison, "~> 4.0.1"},
      {:postgrex, "~> 0.15.1"},
      {:pre_commit, "~> 0.2.4", only: :dev},
      {:sentry, "~> 7.1.0"},
      {:timber, "~> 3.1.2"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
