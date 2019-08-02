defmodule ArWeeklyWeb.PageController do
  use ArWeeklyWeb, :controller
  alias ArWeeklyWeb.SubscriberParams
  alias ArWeekly.Subscribers
  alias ArWeekly.EmailService
  alias ArWeekly.Analytics

  def index(conn, _params) do
    changeset = SubscriberParams.changeset(%SubscriberParams{}, %{})
    render(conn, "index.html", changeset: changeset, is_subscribed: false)
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def subscribe(conn, %{"subscriber_params" => subscriber}) do
    changeset = SubscriberParams.changeset(%SubscriberParams{}, subscriber)

    if changeset.valid? do
      changeset =
        try do
          Subscribers.send_confirmation_email(changeset.changes.email)
          changeset
        rescue
          _ -> SubscriberParams.invalidate_email(changeset)
        end

      render(conn, "index.html",
        changeset: %{changeset | action: :insert},
        is_subscribed: false
      )
    else
      render(conn, "index.html",
        changeset: %{changeset | action: :insert},
        is_subscribed: false
      )
    end
  end

  def confirm_subscription(conn, %{"subscriber" => subscriber}) do
    email = EmailService.arweekly_decode(subscriber)
    Subscribers.confirm_subscription(email)
    changeset = SubscriberParams.changeset(%SubscriberParams{}, %{})
    render(conn, "index.html", changeset: changeset, is_subscribed: true)
  end

  def unsubscribe(conn, %{"subscriber" => enc_email}) do
    email = EmailService.arweekly_decode(enc_email)
    sub = Subscribers.get_by_email!(email)
    Subscribers.update_subscriber(sub, %{is_active: false})
    render(conn, "unsub.html")
  end

  def track_issue(conn, %{"id" => enc_id}) do
    id = EmailService.arweekly_decode(enc_id)
    ids = String.split(id, "@@")
    [issue_number, email] = ids

    if not Analytics.is_issue_tracked(issue_number, email),
      do: Analytics.track_issue(issue_number, email)

    conn
    |> redirect(to: ArWeeklyWeb.Router.Helpers.static_path(conn, "/images/tracking.jpg"))
  end

  def track_issue_link(conn, %{"id" => enc_id}) do
    id = EmailService.arweekly_decode(enc_id)
    ids = String.split(id, "@@")
    [issue_number, email, link] = ids

    if not Analytics.is_link_tracked(issue_number, email, link),
      do: Analytics.track_link(issue_number, email, link)

    conn
    |> redirect(external: link)
  end
end
