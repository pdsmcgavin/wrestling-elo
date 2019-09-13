defmodule Wwelo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wwelo,
      version: "0.4.13",
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
        :edeliver,
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
      {:absinthe, "~> 1.4.13"},
      {:absinthe_plug, "~> 1.4"},
      {:cachex, "~> 3.1"},
      {:cowboy, "~> 2.3"},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:distillery, "~> 1.5", runtime: false},
      {:ecto_enum, "~> 1.1.0"},
      {:edeliver, "~> 1.5.0"},
      {:elixir_mbcs, github: "woxtu/elixir-mbcs", tag: "0.1.3"},
      {:excoveralls, "~> 0.8", only: :test},
      {:floki, "~> 0.18.0"},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 1.0"},
      {:math, "~> 0.3.0"},
      {:mbcs, github: "nekova/erlang-mbcs"},
      {:mock, "~> 0.3.2", only: [:test]},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:pre_commit, "~> 0.2.4", only: :dev},
      {:sentry, "~> 6.4"},
      {:timber, "~> 3.0"}
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
