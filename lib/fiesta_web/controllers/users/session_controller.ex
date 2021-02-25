defmodule FiestaWeb.Users.SessionController do
  use FiestaWeb, :controller

  action_fallback(FiestaWeb.FallbackController)

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, conn} ->
        conn
        |> put_flash(:info, "Invalid email or password")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _) do
    conn
    |> Pow.Plug.delete()
    |> put_flash(:info, "You have successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
