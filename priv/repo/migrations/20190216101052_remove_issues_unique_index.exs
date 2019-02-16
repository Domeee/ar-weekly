defmodule ArWeekly.Repo.Migrations.RemoveIssuesUniqueIndex do
  use Ecto.Migration

  def change do
    drop index("issues", [:number])
  end
end
