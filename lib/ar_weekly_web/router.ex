defmodule ArWeeklyWeb.Router do
  use ArWeeklyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ArWeeklyWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/privacy", PageController, :privacy
    post "/subscribe", PageController, :subscribe
    get "/confirm_subscription/:subscriber", PageController, :confirm_subscription
    get "/unsubscribe/:subscriber", PageController, :unsubscribe
    get "/track_issue/:id", PageController, :track_issue
    get "/track_link/:id", PageController, :track_issue_link
  end

  scope "/*path", ArWeeklyWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end
end
