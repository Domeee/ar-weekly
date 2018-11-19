defmodule ArWeeklyBlog.Repo do
  use Ecto.Repo,
    otp_app: :ar_weekly_blog,
    adapter: Ecto.Adapters.Postgres
end
