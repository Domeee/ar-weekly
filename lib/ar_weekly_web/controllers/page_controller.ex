defmodule ArWeeklyWeb.PageController do
  use ArWeeklyWeb, :controller
  alias ArWeeklyEmail.EmailService
  alias ArWeeklyWeb.SubscriberParams

  def index(conn, _params) do
    changeset = SubscriberParams.changeset(%SubscriberParams{}, %{})
    render(conn, "index.html", changeset: changeset)
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def subscribe(conn, %{"subscriber_params" => subscriber}) do
    changeset = SubscriberParams.changeset(%SubscriberParams{}, subscriber)

    if changeset.valid? do
      EmailService.send_confirmation_email(changeset.changes.email)
    end

    render(conn, "index.html", changeset: %{changeset | action: :validate})
  end

  def confirm_subscription(conn, %{"subscriber" => subscriber}) do
    email = Cipher.decrypt(subscriber)
    ArWeekly.Subscribers.create_subscriber(%{email: email})
    render(conn, "index.html")
  end
end
