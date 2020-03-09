# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :colorify,
  ecto_repos: [Colorify.Repo]

# Configures the endpoint
config :colorify, ColorifyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "46AqvybuMkMbtWTWaBqBu1irZdseNNR15jcHcUBhIMI9KxKkOtMKZYrVru5QoyCQ",
  render_errors: [view: ColorifyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Colorify.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: System.get_env("SIGNING_SALT")]

config :oauth2, debug: true

config :colorify, :oauth,
  client_id: System.get_env("CLIENT_ID"),
  client_secret: System.get_env("CLIENT_SECRET"),
  redirect_uri: System.get_env("REDIRECT_URI")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
