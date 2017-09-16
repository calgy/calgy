use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :calgy_api, CalgyApi.Endpoint,
  http: [port: 4001],
  url: [host: "api.test.calgy.org", port: 4001],
  server: false
