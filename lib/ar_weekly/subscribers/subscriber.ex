defmodule ArWeekly.Subscribers.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string
    field :is_active, :boolean
    field :is_beta, :boolean

    timestamps()
  end

  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [:email, :is_active, :is_beta])
    |> validate_required([:email, :is_active, :is_beta])
    |> unique_constraint(:email)
  end
end
