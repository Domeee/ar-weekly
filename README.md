# AR Weekly

**A weekly email for busy people who care about augmented reality.** [AR Weekly](https://ar-weekly.blog) is a curated list of the most relevant augmented reality news from the week. Sent to your inbox every monday.

## Technology

- [Phoenix](https://phoenixframework.org) is used to build the website and the newsletter engine

## Development Prerequisites

You will need the following things properly installed on your computer.

- [Git](https://git-scm.com)
- [Node.js](https://nodejs.org) (with NPM)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html) (based on Erlang and Elixir)

## Development Installation

```sh
git clone git@github.com:Domeee/ar-weekly.git
cd ar-weekly
mix deps.get
mix ecto.setup
cd assets && npm install
```

## Run development

```sh
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Run prod on localhost

```sh
mix deps.get
cd assets
npm install
npm run deploy
cd ..
mix phx.digest

MIX_ENV=prod mix release --env=prod

# include all env vars
MIX_ENV=prod SECRET_KEY_BASE="$(mix phx.gen.secret)" DATABASE_URL="postgresql://postgres:postgres@localhost:5432/ar_weekly_dev" MY_HOSTNAME=ar-weekly.blog MY_COOKIE=secret REPLACE_OS_VARS=true CIPHER_KEYPHRASE=keyphrase CIPHER_IVPHRASE=ivphrase MAILGUN_API_KEY=api_key MY_NODE_NAME=ar_weekly@127.0.0.1 PORT=4000 \_build/prod/rel/ar_weekly/bin/ar_weekly foreground
```

## Deploy to production

```sh
git push gigalixir master
gigalixir ps:migrate
gigalixir ps:remote_console
seed_script = Path.join(["#{:code.priv_dir(:ar_weekly)}", "repo", "seeds.exs"])
Code.eval_file(seed_script)
```

## Issue releases

### Test release @ localhost (with mix)

```sh
iex -S mix

# Create issue
ArWeekly.Issues.create_issue(:beta, ~D[2019-01-21] \\ Timex.today())

# Send first batch of 80 subscribers
ArWeekly.Issues.release(:beta)

# Send next batch of 80 subscribers
ArWeekly.Issues.release(:beta)
```

### Test release @ production

```sh
gigalixir ps:remote_console

# Create issue
ArWeekly.Issues.create_issue(:prod, ~D[2019-01-21] \\ Timex.today())

# Send first batch of 80 subscribers
ArWeekly.Issues.release(:prod)

# Send next batch of 80 subscribers
ArWeekly.Issues.release(:prod)
```

## Contribute

Pull requests are warmly welcome.
