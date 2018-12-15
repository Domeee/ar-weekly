defmodule ArWeekly.Repo do
  use Ecto.Repo,
    otp_app: :ar_weekly,
    adapter: Ecto.Adapters.Postgres
end
