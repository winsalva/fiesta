defmodule FiestaWeb.Router do
  use FiestaWeb, :router

  import FiestaWeb.UserAuth
  use Pow.Phoenix.Router

  pipeline :protected do
    plug :require_authenticated_user
    plug :put_current_user_id_to_session
    plug :put_root_layout, {FiestaWeb.LayoutView, "app.html"}
  end

  pipeline :not_authenticated do
    plug(:put_layout, {FiestaWeb.LayoutView, "landing_page.html"})
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FiestaWeb do
    pipe_through [:browser, :not_authenticated]

    resources "/", PageController, only: [:index]
  end

  scope "/", FiestaWeb do
    pipe_through [:browser, :not_authenticated]

    post "/signup", UserRegistrationController, :create, as: :signup
    resources "/login", UserSessionController, as: :login, only: [:new, :create]
  end

  scope "/", FiestaWeb do
    pipe_through [:browser, :protected]

    live "/dashboard", DashboardLive.Index, :index, as: :dashboard
    delete "/logout", UserSessionController, :delete, as: :logout

    live "/menu-builder", MenuLive.Edit, :edit, as: :menu
  end
end
