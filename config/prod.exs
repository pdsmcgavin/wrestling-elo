use Mix.Config

config :wwelo, WweloWeb.Endpoint,
  http: [port: 4000, compress: true],
  url: [host: "wwelo.com", port: 4000],
  server: true,
  root: ".",
  version: Mix.Project.config()[:version],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger,
  backends: [Timber.LoggerBackends.HTTP],
  utc_log: true,
  level: :warn

config :sentry,
  dsn: "https://83510e2fdf6e4046b2ad83c670366e3a@sentry.io/1378716",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

config :phoenix, :serve_endpoints, true

import_config "prod.secret.exs"
