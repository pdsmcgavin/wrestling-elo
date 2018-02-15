# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wwelo_api, ecto_repos: [WweloApi.Repo]

# Configures the endpoint
config :wwelo_api, WweloApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "/kaqJnDsob65QTw9zsC6Cw4/tiS4Mksx9/g6399JJYby0HS9flz7+8KrjTSp8NvN",
  render_errors: [view: WweloApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WweloApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
