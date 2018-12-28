defmodule ArWeeklyWeb.SubscriberParams do
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
    |> validate_email(:email)
    |> validate_change(:is_robot, fn :is_robot, is_robot ->
      if is_robot do
        [is_robot: "no robots accepted, sorry ;-)"]
      else
        []
      end
    end)
  end

  def validate_email(changeset, field) do
    value = get_field(changeset, field)

    if not is_nil(value) and Regex.match?(~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/, value) do
      changeset
    else
      invalidate_email(changeset)
    end
  end

  def invalidate_email(changeset) do
    add_error(changeset, :email, "Please provide a valid email")
  end
end
