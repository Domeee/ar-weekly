defmodule ArWeekly.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :email, :string
      add :is_active, :boolean
      add :is_beta, :boolean

      timestamps()
    end

    create unique_index(:subscribers, [:email])
  end
end
