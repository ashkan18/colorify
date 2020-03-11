import Config

config :colorify, :secret_key, System.fetch_env!("SECRET_KEY")

config :colorify, ColorifyWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}],
  check_origin: false,
  server: true,
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY"),
  live_view: [signing_salt: System.get_env("SIGNING_SALT")]

config :colorify, :oauth,
  client_id: System.get_env("CLIENT_ID"),
  client_secret: System.get_env("CLIENT_SECRET"),
  redirect_uri: System.get_env("REDIRECT_URI")
