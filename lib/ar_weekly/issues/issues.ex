defmodule ArWeekly.Issues do
  import Ecto.Query, warn: false
  alias ArWeekly.Repo
  alias ArWeekly.Issues.Issue

  def get_by_number!(number) do
    from(i in Issue, where: i.number == ^number, order_by: i.inserted_at)
    |> Repo.all()
    |> List.last()
  end

  @doc """
  Creates an issue.

  ## Examples

      iex> create_issue(%{field: value})
      {:ok, %Issue{}}

      iex> create_issue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue(attrs \\ %{}) do
    %Issue{}
    |> Issue.changeset(attrs)
    |> Repo.insert()
  end

  def get_latest() do
    query =
      from i in Issue,
        where: fragment("? IN (SELECT MAX(inserted_at) FROM issues)", i.inserted_at),
        select: %{number: i.number, date: i.date}

    Repo.one(query)
  end

  # Send the latest issue to the new sub
  def release_welcome_issue(sub) do
    latest_issue = ArWeekly.Issues.get_latest()

    if latest_issue do
      process_release(latest_issue.number, latest_issue.date, [sub])
    end
  end

  # Create a new issue and send to all subs (:prod -> all, :beta -> beta testers only)
  def release(target \\ :beta, issue_date \\ Timex.today())

  def release(target, issue_date) do
    subs = get_subscribers(target)

    issue_number =
      ArWeekly.Issues.get_latest()
      |> get_issue_number(target)

    process_release(issue_number, issue_date, subs)

    create_issue(%{number: issue_number, date: issue_date})
  end

  defp get_subscribers(:prod) do
    ArWeekly.Subscribers.list_active()
  end

  defp get_subscribers(_) do
    ArWeekly.Subscribers.list_active_betas()
  end

  defp process_release(issue_number, issue_date, subs) do
    issue_filename = Timex.format!(issue_date, "{YYYY}-{M}-{D}")

    html_template =
      Application.app_dir(:ar_weekly, "priv/ar_weekly_issues") <>
        "/" <> issue_filename <> ".html.eex"

    subs
    |> Enum.each(fn sub ->
      tracking_id =
        ArWeekly.EmailService.arweekly_encode(to_string(issue_number) <> "@@" <> sub.email)

      unsubscribe_url =
        ArWeeklyWeb.Router.Helpers.page_url(
          ArWeeklyWeb.Endpoint,
          :unsubscribe,
          ArWeekly.EmailService.arweekly_encode(sub.email)
        )

      html =
        EEx.eval_file(html_template,
          assigns: [
            issue_number: issue_number,
            issue_date: issue_date,
            issue_date_from: Timex.shift(issue_date, days: -7),
            issue_date_to: Timex.shift(issue_date, days: -1),
            next_issue_date: Timex.shift(issue_date, days: 7),
            unsubscribe_url: unsubscribe_url,
            privacy_url: ArWeeklyWeb.Router.Helpers.page_url(ArWeeklyWeb.Endpoint, :privacy),
            issue_tracking_url:
              ArWeeklyWeb.Router.Helpers.page_url(ArWeeklyWeb.Endpoint, :track_issue, tracking_id),
            logo_url:
              ArWeeklyWeb.Router.Helpers.static_url(
                ArWeeklyWeb.Endpoint,
                "/images/ar-weekly-logo-email.png"
              ),
            subscriber_email: sub.email
          ]
        )

      ArWeekly.EmailService.send_email(
        sub.email,
        {"AR Weekly", "hello@ar-weekly.blog"},
        "AR Weekly Newsletter Issue ##{issue_number}",
        Premailex.to_inline_css(html),
        Premailex.to_text(html),
        unsubscribe_url
      )
    end)

    issue_number
  end

  defp get_issue_number(nil, _) do
    1
  end

  defp get_issue_number(issue, :prod) do
    issue.number + 1
  end

  defp get_issue_number(issue, :beta) do
    issue.number
  end
end
