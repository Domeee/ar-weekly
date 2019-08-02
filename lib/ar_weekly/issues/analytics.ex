defmodule ArWeekly.Analytics do
  import Ecto.Query, warn: false
  alias ArWeekly.Repo

  alias ArWeekly.Issues.Issue
  alias ArWeekly.Issues.LinkTracking
  alias ArWeekly.Issues.Tracking
  alias ArWeekly.Subscribers.Subscriber

  def is_link_tracked(issue_number, subscriber_email, link) do
    query =
      from l in LinkTracking,
        join: i in Issue,
        on: l.issue_id == i.id,
        join: s in Subscriber,
        on: l.subscriber_id == s.id,
        where: i.number == ^issue_number and s.email == ^subscriber_email and l.link == ^link,
        select: %{
          issue_id: i.id
        }

    Repo.all(query)
    |> length() > 0
  end

  def is_issue_tracked(issue_number, subscriber_email) do
    query =
      from t in Tracking,
        join: i in Issue,
        on: t.issue_id == i.id,
        join: s in Subscriber,
        on: t.subscriber_id == s.id,
        where: i.number == ^issue_number and s.email == ^subscriber_email,
        select: %{
          issue_id: i.id
        }

    Repo.all(query)
    |> length() > 0
  end

  def track_issue(issue_number, subscriber_email) do
    issue = ArWeekly.Issues.get_by_number!(issue_number)
    subscriber = ArWeekly.Subscribers.get_by_email!(subscriber_email)

    track_issue(%{
      issue_id: issue.id,
      subscriber_id: subscriber.id
    })
  end

  defp track_issue(attrs) do
    %Tracking{}
    |> Tracking.changeset(attrs)
    |> Repo.insert()
  end

  def track_link(attrs \\ %{}) do
    %LinkTracking{}
    |> LinkTracking.changeset(attrs)
    |> Repo.insert()
  end

  def track_link(issue_number, subscriber_email, link) do
    issue = ArWeekly.Issues.get_by_number!(issue_number)
    subscriber = ArWeekly.Subscribers.get_by_email!(subscriber_email)

    track_link(%{
      issue_id: issue.id,
      subscriber_id: subscriber.id,
      link: link
    })

    if not is_issue_tracked(issue_number, subscriber_email) do
      track_issue(issue_number, subscriber_email)
    end
  end
end
