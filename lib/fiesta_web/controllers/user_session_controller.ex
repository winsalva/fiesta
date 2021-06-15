defmodule FiestaWeb.UserSessionController do
  use FiestaWeb, :controller

  alias Fiesta.Accounts
  alias Fiesta.Accounts.User
  alias FiestaWeb.UserAuth

  def new(conn, _params) do
    changeset = User.login_changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{}, user_params)

    with %{valid?: true, changes: %{email: email, password: password}} <- changeset,
         user when not is_nil(user) <- Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_session(:user_return_to, Routes.dashboard_path(conn, :index))
      |> UserAuth.log_in_user(user, user_params)
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully")
    |> UserAuth.log_out_user()
  end
end
