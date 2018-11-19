use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ar_weekly_blog, ArWeeklyBlogWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ar_weekly_blog, ArWeeklyBlog.Repo,
  username: "postgres",
  password: "postgres",
  database: "ar_weekly_blog_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
