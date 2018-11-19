defmodule ArWeeklyBlog.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :email, :string

      timestamps()
    end

    create unique_index(:subscribers, [:email])
  end
end
