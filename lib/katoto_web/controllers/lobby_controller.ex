defmodule KusinaWeb.LobbyController do
  use KusinaWeb, :controller

  alias KusinaWeb.LobbyLive

  def index(conn, _params) do
    live_render(conn, LobbyLive)
  end
end
