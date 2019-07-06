defmodule DouzhizhuWeb.Router do
  use DouzhizhuWeb, :router

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

  scope "/", DouzhizhuWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/tables", PageController, :tables
  end

  # Other scopes may use custom stacks.
  # scope "/api", DouzhizhuWeb do
  #   pipe_through :api
  # end
end
