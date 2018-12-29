defmodule ArWeekly.Subscribers.SignUp do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sign_ups" do
    field :email, :string

    timestamps()
  end

  def changeset(sign_up, attrs) do
    sign_up
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
