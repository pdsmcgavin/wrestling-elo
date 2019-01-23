use Mix.Config

config :wwelo, WweloWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, :console, format: "[$level] $message\n", level: :warn

config :wwelo, Wwelo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wwelo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :wwelo, :children, [Wwelo.Repo, WweloWeb.Endpoint]
