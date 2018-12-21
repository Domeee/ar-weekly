defmodule ArWeeklyWeb.PageController do
  use ArWeeklyWeb, :controller
  alias ArWeeklyWeb.SubscriberParams

  def index(conn, _params) do
    changeset = SubscriberParams.changeset(%SubscriberParams{}, %{})
    render(conn, "index.html", changeset: changeset, is_subscribed: false)
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def subscribe(conn, %{"subscriber_params" => subscriber}) do
    changeset = SubscriberParams.changeset(%SubscriberParams{}, subscriber)
    IO.inspect(changeset)

    if changeset.valid? do
      ArWeekly.Subscribers.send_confirmation_email(changeset.changes.email)
    end

    render(conn, "index.html",
      changeset: %{changeset | action: :validate},
      is_subscribed: false
    )
  end

  def confirm_subscription(conn, %{"subscriber" => subscriber}) do
    email = ArWeekly.EmailService.arweekly_decode(subscriber)
    IO.inspect(email)

    with {:ok, sub} <-
           ArWeekly.Subscribers.create_subscriber(%{email: email, is_active: true, is_beta: false}) do
      ArWeekly.Issues.release_welcome_issue(sub)
    end

    changeset = SubscriberParams.changeset(%SubscriberParams{}, %{})
    render(conn, "index.html", changeset: changeset, is_subscribed: true)
  end

  def unsubscribe(conn, %{"subscriber" => enc_email}) do
    email = ArWeekly.EmailService.arweekly_decode(enc_email)
    subscriber = ArWeekly.Subscribers.get_by_email!(email)
    ArWeekly.Subscribers.update_subscriber(subscriber, %{is_active: false})
    render(conn, "unsub.html")
  end

  def track_issue(conn, %{"id" => enc_id}) do
    id = ArWeekly.EmailService.arweekly_decode(enc_id)
    ids = String.split(id, "@@")
    [issue_number, email] = ids
    issue = ArWeekly.Issues.get_by_number!(issue_number)
    sub = ArWeekly.Subscribers.get_by_email!(email)

    ArWeekly.Issues.create_tracking(%{issue_id: issue.id, subscriber_id: sub.id})

    conn
    |> redirect(to: ArWeeklyWeb.Router.Helpers.static_path(conn, "/images/tracking.jpg"))
  end

  def track_issue_link(conn, %{"id" => enc_id}) do
    id = ArWeekly.EmailService.arweekly_decode(enc_id)
    ids = String.split(id, "@@")
    [issue_number, subscriber_email, link] = ids
    link_tracking = ArWeekly.Issues.get_link_tracking!(issue_number, subscriber_email, link)

    if link_tracking == [],
      do: ArWeekly.Issues.create_link_tracking(issue_number, subscriber_email, link)

    conn
    |> redirect(external: link)
  end
end
