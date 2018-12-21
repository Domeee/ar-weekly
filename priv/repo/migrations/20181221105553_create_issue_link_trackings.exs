defmodule ArWeekly.Repo.Migrations.CreateIssueLinkTrackings do
  use Ecto.Migration

  def change do
    create table(:issue_link_trackings) do
      add :link, :string
      add :issue_id, references(:issues, on_delete: :nothing)
      add :subscriber_id, references(:subscribers, on_delete: :nothing)

      timestamps()
    end

    create index(:issue_link_trackings, [:issue_id])
    create index(:issue_link_trackings, [:subscriber_id])
  end
end
