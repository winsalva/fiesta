defmodule FiestaWeb.Users.RegistrationController do
  use FiestaWeb, :controller

  alias FiestaWeb.PageView
  alias Pow.Plug, as: PowPlug

  action_fallback(FiestaWeb.FallbackController)

  def create(conn, %{"user" => user_params}) do
    conn
    |> PowPlug.create_user(user_params)
    |> case do
      {:ok, _, conn} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, changeset, conn} ->
        conn
        |> put_view(PageView)
        |> render(:index, changeset: changeset)
    end
  end
end
