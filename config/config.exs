# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pool_games,
  ecto_repos: [PoolGames.Repo]

# Configures the endpoint
config :pool_games, PoolGamesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "d5XrTPjCHt4qkQ27ZeqMnzbCWhXiInKeJSOsqIe3QbJnhlJX+x/5jURNboY5v8b9",
  render_errors: [view: PoolGamesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PoolGames.PubSub,
  live_view: [signing_salt: "8P7dpiQq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
