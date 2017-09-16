use Mix.Config

config :calgy,
  ecto_repos: [Calgy.Repo],
  generators: [binary_id: true]

import_config "#{Mix.env}.exs"
