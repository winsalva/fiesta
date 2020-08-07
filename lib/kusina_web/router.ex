defmodule KusinaWeb.Router do
  use KusinaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {KusinaWeb.LayoutView, "app.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KusinaWeb do
    pipe_through :browser

    resources "/", PageController, only: [:index]
    resources "/lobby", LobbyController, only: [:index]
    live "/chat/:id", ChatLive, layout: {KusinaWeb.LayoutView, "app.html"}
  end

  # Other scopes may use custom stacks.
  # scope "/api", KusinaWeb do
  #   pipe_through :api
  # end
end
