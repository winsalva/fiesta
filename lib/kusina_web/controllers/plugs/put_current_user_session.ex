defmodule KusinaWeb.Plugs.PutCurrentUserSession do
  @moduledoc """
  Puts current user's id into session for live view consumption
  """
  @behaviour Plug
  import Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case Pow.Plug.current_user(conn) do
      nil -> conn
      %{id: id} -> put_session(conn, "user_id", id)
    end
  end
end
