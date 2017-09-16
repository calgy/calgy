use Mix.Config

# Configure your database
config :calgy, Calgy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  database: "calgy_test",
  hostname: System.get_env("PGHOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
