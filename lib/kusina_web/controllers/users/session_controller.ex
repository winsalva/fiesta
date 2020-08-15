defmodule KusinaWeb.Users.SessionController do
  use KusinaWeb, :controller

  import KusinaWeb.ControllerHelpers

  alias Kusina.Users

  @redirect_token_salt Application.get_env(:kusina, :redirect_token_salt)

  action_fallback(KusinaWeb.FallbackController)

  def signin_redirect(conn, %{"token" => token}) do
    with {:ok, {user_id, token_timeout}} <-
           Phoenix.Token.decrypt(conn, @redirect_token_salt, token),
         :ok <- verify_token_expiry(token_timeout),
         user when not is_nil(user) <- Users.get_by(id: user_id) do
      conn
      |> Pow.Plug.create(user)
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      _ -> :not_authenticated
    end
  end

  def delete(conn, _) do
    conn
    |> Pow.Plug.delete()
    |> put_flash(:info, "You have successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
