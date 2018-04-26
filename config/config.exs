# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wwelo, ecto_repos: [Wwelo.Repo]

# Configures the endpoint
config :wwelo, WweloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "z0hj8Xc8+FPtYzN28hssbjyswpTsFS2Z12QwHa4V5cC0akE2E9o8MlUnNwxJxpVy",
  render_errors: [view: WweloWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wwelo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Pre-commit hooks
config :pre_commit,
  commands: ["format", "coveralls"],
  verbose: true
