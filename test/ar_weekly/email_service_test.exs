defmodule ArWeekly.EmailServiceTest do
  use ExUnit.Case, async: true
  use Bamboo.Test
  import ArWeekly.EmailService

  # Comment out the following line in test.exs config to use this test to send real emails
  # config :ar_weekly, ArWeekly.Mailer, adapter: Bamboo.TestAdapter
  test "send email" do
    html = """
    <a href="https://ar-weekly.blog">AR Weekly</a>
    """

    text = """
      AR Weekly
    """

    email =
      send_email(
        "dominique+arweeklytest@donhubi.ch",
        "hello@ar-weekly.blog",
        "send email test",
        html,
        text
      )

    assert_delivered_email(email)
  end
end
