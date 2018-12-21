use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ar_weekly, ArWeeklyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ar_weekly, ArWeekly.Repo,
  username: "postgres",
  password: "postgres",
  database: "ar_weekly_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ar_weekly, ArWeekly.Mailer, adapter: Bamboo.TestAdapter
