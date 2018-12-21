defmodule ArWeekly.Issues.Tracking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issue_trackings" do
    field :issue_id, :id
    field :subscriber_id, :id

    timestamps()
  end

  def changeset(tracking, attrs) do
    tracking
    |> cast(attrs, [:issue_id, :subscriber_id])
    |> validate_required([:issue_id, :subscriber_id])
  end
end
