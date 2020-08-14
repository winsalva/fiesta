defmodule KusinaWeb.FallbackController do
  use KusinaWeb, :controller

  alias Plug.Conn

  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, :not_authenticated) do
    conn
    |> put_flash(:error, "You've to be authenticated first")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  @spec call(Conn.t(), tuple()) :: Conn.t()
  def call(conn, {:error, :token_timeout}) do
    conn
    |> put_flash(:error, "Token we received already timed out. Please login or register again.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, :already_authenticated) do
    conn
    |> put_flash(:error, "You're already authenticated")
    |> redirect(to: Routes.lobby_path(conn, :index))
  end
end
