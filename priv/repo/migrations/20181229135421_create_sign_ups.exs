defmodule ArWeekly.Repo.Migrations.CreateSignUps do
  use Ecto.Migration

  def change do
    create table(:sign_ups) do
      add :email, :string

      timestamps()
    end
  end
end
