defmodule FiestaWeb.Users.RegistrationController do
  use FiestaWeb, :controller

  action_fallback(FiestaWeb.FallbackController)

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, _changeset, conn} ->
        conn
        |> put_flash(:error, "Error signing up. Please try again later.")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
