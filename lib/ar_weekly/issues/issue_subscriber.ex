defmodule ArWeekly.Issues.IssueSubscriber do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "issues_subscribers" do
    field :issue_id, :id
    field :subscriber_id, :id

    timestamps()
  end

  @doc false
  def changeset(issue_subscriber, attrs) do
    issue_subscriber
    |> cast(attrs, [:issue_id, :subscriber_id])
    |> validate_required([:issue_id, :subscriber_id])
    |> foreign_key_constraint(:issue_id)
    |> foreign_key_constraint(:subscriber_id)
    |> unique_constraint(:issue_id, name: :issues_subscribers_issue_id_subscriber_id_index)
  end
end
