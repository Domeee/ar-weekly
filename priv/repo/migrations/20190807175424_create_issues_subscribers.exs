defmodule ArWeekly.Repo.Migrations.CreateIssuesSubscribers do
  use Ecto.Migration

  def change do
    create table(:issues_subscribers, primary_key: false) do
      add :issue_id, references(:issues, on_delete: :delete_all)
      add :subscriber_id, references(:subscribers, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:issues_subscribers, [:issue_id, :subscriber_id])
  end
end
