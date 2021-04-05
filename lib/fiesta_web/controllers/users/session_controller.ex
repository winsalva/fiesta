defmodule FiestaWeb.Users.SessionController do
  use FiestaWeb, :controller
  alias Fiesta.Users.User
  alias FiestaWeb.Pow.SessionView

  action_fallback(FiestaWeb.FallbackController)

  def new(conn, _) do
    changeset = User.changeset(%User{}, %{})

    conn
    |> put_view(SessionView)
    |> render("new.html", changeset: changeset)
  end

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
        |> put_status(422)
        |> put_flash(:error, "Invalid email or password")
        |> put_view(SessionView)
        |> render("new.html", changeset: Pow.Plug.change_user(conn, user_params))
    end
  end

  def delete(conn, _) do
    conn
    |> Pow.Plug.delete()
    |> put_flash(:info, "You have successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
