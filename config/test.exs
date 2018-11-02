use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wwelo, WweloWeb.Endpoint,
  http: [port: 4001],
  server: false

# config :logger, level: :warn
config :logger, :console, format: "[$level] $message\n", level: :info

# Configure your database
config :wwelo, Wwelo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wwelo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :wwelo, :children, [Wwelo.Repo, WweloWeb.Endpoint]
