use Mix.Config

config :wwelo, ecto_repos: [Wwelo.Repo]

config :wwelo, WweloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "z0hj8Xc8+FPtYzN28hssbjyswpTsFS2Z12QwHa4V5cC0akE2E9o8MlUnNwxJxpVy",
  render_errors: [view: WweloWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wwelo.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  compile_time_purge_level: :error

config :wwelo, :environment, Mix.env()

config :wwelo, :children, [
  Wwelo.Repo,
  WweloWeb.Endpoint,
  Wwelo.Updater,
  {Cachex, [:wwelo_cache]}
]

import_config "#{Mix.env()}.exs"
