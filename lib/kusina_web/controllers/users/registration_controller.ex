defmodule KusinaWeb.Users.RegistrationController do
  use KusinaWeb, :controller

  import KusinaWeb.ControllerHelpers

  alias Kusina.Users

  @redirect_token_salt Application.get_env(:kusina, :redirect_token_salt)

  action_fallback(KusinaWeb.FallbackController)

  def signup_redirect(conn, %{"token" => token}) do
    with {:ok, {user_id, token_timeout}} <-
           Phoenix.Token.decrypt(conn, @redirect_token_salt, token),
         :ok <- verify_token_expiry(token_timeout),
         user when not is_nil(user) <- Users.get_by(id: user_id) do
      conn
      |> Pow.Plug.create(user)
      |> put_flash(:info, "Welcome!")
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      _ -> :not_authenticated
    end
  end
end
