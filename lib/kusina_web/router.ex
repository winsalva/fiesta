defmodule KusinaWeb.Router do
  use KusinaWeb, :router
  use Pow.Phoenix.Router

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: KusinaWeb.FallbackController

    plug KusinaWeb.Plugs.PutCurrentUserSession
    plug :put_layout, {KusinaWeb.LayoutView, "app.html"}
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: KusinaWeb.FallbackController
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KusinaWeb do
    pipe_through :browser

    resources "/", PageController, only: [:index]
  end

  scope "/", KusinaWeb do
    pipe_through [:browser, :not_authenticated]

    post "/signup", Users.RegistrationController, :create, as: :signup
    post "/login", Users.SessionController, :create, as: :login
  end

  scope "/", KusinaWeb do
    pipe_through [:browser, :protected]

    resources "/dashboard", DashboardController, only: [:index]
    resources "/lobby", LobbyController, only: [:index]
    delete "/logout", Users.SessionController, :delete, as: :logout

    live "/kitchen", KitchenLive.Index, layout: {KusinaWeb.LayoutView, "app.html"}
    live "/chat/:id", ChatLive, layout: {KusinaWeb.LayoutView, "app.html"}
  end

  # Other scopes may use custom stacks.
  # scope "/api", KusinaWeb do
  #   pipe_through :api
  # end
end
