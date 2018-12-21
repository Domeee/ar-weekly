defmodule ArWeekly.Repo.Migrations.CreateIssueTrackings do
  use Ecto.Migration

  def change do
    create table(:issue_trackings) do
      add :issue_id, references(:issues, on_delete: :delete_all)
      add :subscriber_id, references(:subscribers, on_delete: :delete_all)

      timestamps()
    end

    create index(:issue_trackings, [:issue_id])
    create index(:issue_trackings, [:subscriber_id])
  end
end
