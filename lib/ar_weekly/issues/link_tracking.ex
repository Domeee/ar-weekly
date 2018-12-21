defmodule ArWeekly.Issues.LinkTracking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issue_link_trackings" do
    field :link, :string
    field :issue_id, :id
    field :subscriber_id, :id

    timestamps()
  end

  def changeset(link_tracking, attrs) do
    link_tracking
    |> cast(attrs, [:link, :issue_id, :subscriber_id])
    |> validate_required([:link, :issue_id, :subscriber_id])
  end
end
