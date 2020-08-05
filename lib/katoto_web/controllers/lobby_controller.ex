defmodule KatotoWeb.LobbyController do
  use KatotoWeb, :controller

  alias KatotoWeb.LobbyLive

  def index(conn, _params) do
    live_render(conn, LobbyLive)
  end
end
