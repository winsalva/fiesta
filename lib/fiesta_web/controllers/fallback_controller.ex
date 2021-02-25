defmodule FiestaWeb.FallbackController do
  use FiestaWeb, :controller

  alias Plug.Conn

  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, :not_authenticated) do
    conn
    |> put_flash(:error, "You've to be authenticated first")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def call(conn, {:error, :token_timeout}) do
    conn
    |> put_flash(:error, "Token we received already timed out. Please login or register again.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def call(conn, :already_authenticated) do
    conn
    |> put_flash(:error, "You're already authenticated")
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
