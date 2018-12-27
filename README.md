# ArWeekly

**A weekly email for busy people who care about augmented reality.** AR Weekly is a curated list of the most relevant augmented reality news from the week. Sent to your inbox every monday.

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

## Deploy to production

`git push gigalixir master`

## Contribute

Pull requests are warmly welcome.
