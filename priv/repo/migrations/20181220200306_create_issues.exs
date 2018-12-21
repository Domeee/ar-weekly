defmodule ArWeekly.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :number, :integer
      add :date, :date

      timestamps()
    end

    create unique_index(:issues, [:number])
  end
end
