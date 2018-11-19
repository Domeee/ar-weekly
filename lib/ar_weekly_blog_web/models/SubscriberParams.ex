defmodule ArWeeklyBlogWeb.SubscriberParams do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:email)
    field(:is_robot, :boolean)
  end

  def changeset(model, params) do
    model
    |> cast(params, [:email, :is_robot])
    |> validate_required(:email)
    |> validate_change(:is_robot, fn :is_robot, is_robot ->
      if is_robot do
        [is_robot: "no robots accepted, sorry ;-)"]
      else
        []
      end
    end)
  end
end
