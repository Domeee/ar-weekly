defmodule ArWeekly.EmailService do
  import Bamboo.Email

  def send_email(recipient, from, subject, html_body, text_body, list_unsub \\ nil) do
    email =
      new_email()
      |> to(recipient)
      |> from(from)
      |> subject(subject)
      |> html_body(html_body)
      |> text_body(text_body)

    email =
      if not is_nil(list_unsub),
        do: put_header(email, "List-Unsubscribe", "<#{list_unsub}>"),
        else: email

    ArWeekly.Mailer.deliver_now(email)
  end

  def arweekly_encode(string) do
    str_enc = Cipher.encrypt(string)
    Base.url_encode64(str_enc)
  end

  def arweekly_decode(string) do
    str_enc = Base.url_decode64!(string)
    Cipher.decrypt(str_enc)
  end
end
