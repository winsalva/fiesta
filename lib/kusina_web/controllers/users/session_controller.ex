defmodule KusinaWeb.Users.SessionController do
  use KusinaWeb, :controller

  import KusinaWeb.ControllerHelpers

  alias Kusina.Users

  @redirect_token_salt Application.compile_env!(:kusina, :redirect_token_salt)

  action_fallback(KusinaWeb.FallbackController)

  def callback(conn, %{"provider" => "self", "token" => token, "type" => type}) do
    with {:ok, {user_id, token_timeout}} <-
           Phoenix.Token.decrypt(conn, @redirect_token_salt, token),
         :ok <- verify_token_expiry(token_timeout),
         user when not is_nil(user) <- Users.get_by(id: user_id) do
      conn
      |> Pow.Plug.create(user)
      |> put_callback_flash(type)
      |> redirect_callback(type)
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

  defp put_callback_flash(conn, "sign_in"), do: put_flash(conn, :info, "Welcome back!")
  defp put_callback_flash(conn, _), do: put_flash(conn, :info, "Welcome!")

  defp redirect_callback(conn, "sign_in"),
    do: redirect(conn, to: Routes.dashboard_path(conn, :index))

  defp redirect_callback(conn, _), do: redirect(conn, to: Routes.dashboard_path(conn, :index))
end
