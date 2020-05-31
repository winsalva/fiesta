defmodule KatotoWeb.Router do
  use KatotoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {KatotoWeb.LayoutView, "app.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KatotoWeb do
    pipe_through :browser

    live "/", LobbyLive
    live "/chat/:id", ChatLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", KatotoWeb do
  #   pipe_through :api
  # end
end
