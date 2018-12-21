defmodule ArWeekly.Subscribers do
  @moduledoc """
  The Subscribers context.
  """

  import Ecto.Query, warn: false
  alias ArWeekly.Repo

  alias ArWeekly.Subscribers.Subscriber

  def list_active() do
    query = from(s in Subscriber, where: s.is_active)
    Repo.all(query)
  end

  def list_active_betas() do
    query = from(s in Subscriber, where: s.is_active and s.is_beta)
    Repo.all(query)
  end

  def get_by_email!(email) do
    query = from(s in Subscriber, where: s.email == ^email)
    Repo.one!(query)
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
    rec_enc = ArWeekly.EmailService.arweekly_encode(recipient)
    url = ArWeeklyWeb.Endpoint.url()

    html = """
    <table style="font-family: Verdana, Geneva, Tahoma, sans-serif;font-size: 16px;line-height: 24px;color: rgba(0, 0, 0, 0.8);">
      <tr><td><h1 style="margin: 0;font-size: 22px;font-weight: bold;color: #2c3e50;">AR Weekly</h1></td></tr>
      <tr><td><p>You receive this Email because you subscribed to the AR Weekly Blog. To complete your subscription please confirm you email address by clicking on the following link:</p></td></tr>
      <tr><td><p><a href="#{url}/confirm_subscription/#{rec_enc}" style="color: #ca3827;">#{url}/confirm_subscription/#{
      rec_enc
    }</a></p></td></tr>
      <tr><td><p>Thank you and best regards<br><span style="color: #2c3e50;"><strong>AR</strong>&nbsp;Weekly</span></p></td></tr>
    </table>
    """

    text = """
      AR Weekly\r\n\r\n
      You receive this Email because you subscribed to the AR Weekly Blog. To complete your subscription please confirm you email address by clicking on the following link:\r\n
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
end
