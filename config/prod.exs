use Mix.Config

config :ar_weekly, ArWeeklyWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}],
  server: true,
  url: [host: "ar-weekly.blog", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: "${SECRET_KEY_BASE}"

config :ar_weekly, ArWeekly.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}",
  database: "",
  pool_size: 2

config :ar_weekly, ArWeekly.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "${MAILGUN_API_KEY}",
  domain: "ar-weekly.blog"

# Cypher configuration
config :cipher,
  keyphrase: "${CIPHER_KEYPHRASE}",
  ivphrase: "${CIPHER_IVPHRASE}",
  magic_token: "${CIPHER_MAGICTOKEN}"

# Do not print debug messages in production
config :logger, level: :info
