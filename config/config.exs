# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :calgy_api,
  ecto_repos: [CalgyApi.Repo]

# Configures the endpoint
config :calgy_api, CalgyApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ByxVWRP8apFhWRS8dWA1WkB5WIj1GGjnVWuHepkS7S0/AU5qaAq+F0eej906J+K/",
  render_errors: [view: CalgyApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: CalgyApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
