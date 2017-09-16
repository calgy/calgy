use Mix.Config

# Configure your database
config :calgy, Calgy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  database: System.get_env("PGDATABASE") || "calgy_dev",
  hostname: System.get_env("PGHOST") || "localhost",
  pool_size: 10
