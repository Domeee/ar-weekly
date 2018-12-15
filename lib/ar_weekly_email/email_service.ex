defmodule ArWeeklyEmail.EmailService do
  import Bamboo.Email

  def send_confirmation_email(recipient) do
    rec_enc = Cipher.encrypt(recipient)

    html = """
    <table style="font-family: Verdana, Geneva, Tahoma, sans-serif;font-size: 16px;line-height: 24px;color: rgba(0, 0, 0, 0.8);">
      <tr><td><h1 style="margin: 0;font-size: 22px;font-weight: bold;color: #2c3e50;">AR Weekly</h1></td></tr>
      <tr><td><p>You receive this Email because you subscribed to the AR Weekly Blog. To complete your subscription please confirm you email address by clicking on the following link:</p></td></tr>
      <tr><td><p><a href="https://ar-weekly.blog/confirm_subscription/#{rec_enc}" style="color: #ca3827;">https://ar-weekly.blog/confirm_subscription/#{
      rec_enc
    }</a></p></td></tr>
      <tr><td><p>Thank you and best regards<br><span style="color: #2c3e50;"><strong>AR</strong>&nbsp;Weekly</span></p></td></tr>
    </table>
    """

    text = """
      AR Weekly\r\n\r\n
      You receive this Email because you subscribed to the AR Weekly Blog. To complete your subscription please confirm you email address by clicking on the following link:\r\n
      https://ar-weekly.blog/confirm_subscription/#{rec_enc}\r\n\r\n
      Thank you and best regards\r\n
      AR Weekly
    """

    send_email(
      recipient,
      "hello@ar-weekly.blog",
      "Please confirm you AR Weekly subscription",
      html,
      text
    )
  end

  def send_email(recipient, from, subject, html_body, text_body) do
    email =
      new_email(
        to: recipient,
        from: from,
        subject: subject,
        html_body: html_body,
        text_body: text_body
      )

    ArWeeklyEmail.Mailer.deliver_now(email)
  end
end
