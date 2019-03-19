use Mix.Config

config :wwelo, WweloWeb.Endpoint,
  http: [
    port: 4000
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/.bin/webpack-dev-server",
      "--inline",
      "--colors",
      "--hot",
      "--stdin",
      "--host",
      "0.0.0.0",
      "--port",
      "8080",
      "--public",
      "0.0.0.0:8080",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :wwelo, WweloWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/wwelo_web/views/.*(ex)$},
      ~r{lib/wwelo_web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n", level: :info

config :phoenix, :stacktrace_depth, 20

config :wwelo, Wwelo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wwelo_dev",
  hostname: "0.0.0.0",
  pool_size: 10

config :wwelo, :children, [
  Wwelo.Repo,
  WweloWeb.Endpoint,
  {Cachex, :wwelo_cache}
]

config :pre_commit,
  commands: [
    "format",
    "coveralls",
    "credo",
    "dialyzer",
    "match_elo_consts_json",
    "run_eslint",
    "run_jest"
  ],
  verbose: true
