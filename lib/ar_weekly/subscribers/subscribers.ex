defmodule ArWeekly.Subscribers do
  @moduledoc """
  The Subscribers context.
  """

  import Ecto.Query, warn: false
  alias ArWeekly.Repo

  alias ArWeekly.Subscribers.Subscriber
  alias ArWeekly.Subscribers.SignUp
  alias ArWeekly.Issues.IssueSubscriber

  def get_subscribers_batch_for_issue(:prod, latest_issue_id) do
    subs_done =
      from is in IssueSubscriber,
        join: s in Subscriber,
        on: is.subscriber_id == s.id,
        where: is.issue_id == ^latest_issue_id,
        where: s.is_active,
        where: not s.is_beta,
        select: %{id: is.subscriber_id, email: s.email}

    from(s in Subscriber,
      select: %{id: s.id, email: s.email},
      where: s.is_active,
      where: not s.is_beta,
      except_all: ^subs_done,
      limit: 80
    )
    |> Repo.all()
  end

  def get_subscribers_batch_for_issue(:beta, latest_issue_id) do
    subs_done =
      from is in IssueSubscriber,
        join: s in Subscriber,
        on: is.subscriber_id == s.id,
        where: is.issue_id == ^latest_issue_id,
        where: s.is_active,
        where: s.is_beta,
        select: %{id: is.subscriber_id, email: s.email}

    from(s in Subscriber,
      select: %{id: s.id, email: s.email},
      where: s.is_active,
      where: s.is_beta,
      except_all: ^subs_done,
      limit: 80
    )
    |> Repo.all()
  end

  def get_by_email(email) do
    from(s in Subscriber, where: s.email == ^email)
    |> Repo.one()
  end

  def get_by_email!(email) do
    from(s in Subscriber, where: s.email == ^email)
    |> Repo.one!()
  end

  @doc """
  Creates a subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscriber(attrs \\ %{}) do
    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a sign up.

  ## Examples

      iex> create_sign_up(%{field: value})
      {:ok, %SignUp{}}

      iex> create_sign_up(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sign_up(attrs \\ %{}) do
    %SignUp{}
    |> SignUp.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a sign up.

  ## Examples

      iex> delete_sign_up(signup)
      {:ok, %SignUp{}}

      iex> delete_sign_up(signup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sign_up_by_email(email) do
    from(s in SignUp, where: s.email == ^email)
    |> Repo.delete_all()
  end

  @doc """
  Updates a subscriber.

  ## Examples

      iex> update_subscriber(subscriber, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(subscriber, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscriber(%Subscriber{} = subscriber, attrs) do
    subscriber
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  def send_confirmation_email(recipient) do
    ArWeekly.Subscribers.create_sign_up(%{email: recipient})

    rec_enc = ArWeekly.EmailService.arweekly_encode(recipient)
    url = ArWeeklyWeb.Endpoint.url()

    html = """
    <table style="font-family: Verdana, Geneva, Tahoma, sans-serif;font-size: 16px;line-height: 24px;color: rgba(0, 0, 0, 0.8);">
      <tr><td><h1 style="margin: 0;font-size: 22px;font-weight: bold;color: #2c3e50;">AR Weekly</h1></td></tr>
      <tr><td><p>You receive this Email because you subscribed to the AR Weekly Blog. To complete your subscription please confirm your email address by clicking on the following link:</p></td></tr>
      <tr><td><p><a href="#{url}/confirm_subscription/#{rec_enc}" style="color: #ca3827;">#{url}/confirm_subscription/#{
      rec_enc
    }</a></p></td></tr>
      <tr><td><p>Thank you and best regards<br><span style="color: #2c3e50;"><strong>AR</strong>&nbsp;Weekly</span></p></td></tr>
    </table>
    """

    text = """
      AR Weekly\r\n\r\n
      You receive this Email because you subscribed to the AR Weekly Blog. To complete your subscription please confirm your email address by clicking on the following link:\r\n
      #{url}/confirm_subscription/#{rec_enc}\r\n\r\n
      Thank you and best regards\r\n
      AR Weekly
    """

    ArWeekly.EmailService.send_email(
      recipient,
      {"AR Weekly", "hello@ar-weekly.blog"},
      "Please confirm you AR Weekly subscription",
      html,
      text
    )
  end

  def confirm_subscription(email) do
    ArWeekly.Subscribers.delete_sign_up_by_email(email)

    case ArWeekly.Subscribers.get_by_email(email) do
      nil ->
        with {:ok, sub} <-
               ArWeekly.Subscribers.create_subscriber(%{
                 email: email,
                 is_active: true,
                 is_beta: false
               }) do
          ArWeekly.Issues.release_welcome_issue(sub)
        end

      sub ->
        ArWeekly.Subscribers.update_subscriber(sub, %{is_active: true})
    end
  end
end
