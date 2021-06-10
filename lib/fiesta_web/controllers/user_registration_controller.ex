defmodule FiestaWeb.UserRegistrationController do
  use FiestaWeb, :controller

  alias Fiesta.Accounts
  alias Fiesta.Accounts.User
  alias FiestaWeb.UserAuth
  alias FiestaWeb.PageView

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # {:ok, _} =
        #   Accounts.deliver_user_confirmation_instructions(
        #     user,
        #     &Routes.user_confirmation_url(conn, :confirm, &1)
        #   )

        conn
        |> put_session(:user_return_to, Routes.dashboard_path(conn, :index))
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> put_view(PageView)
        |> render(:index, changeset: changeset)
    end
  end
end
