defmodule ArWeekly.Issues.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :date, :date
    field :number, :integer

    timestamps()
  end

  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:number, :date])
    |> validate_required([:number, :date])
    |> unique_constraint(:number)
  end
end
