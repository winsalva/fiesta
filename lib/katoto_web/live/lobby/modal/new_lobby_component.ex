defmodule KatotoWeb.Modal.NewLobbyComponent do
  use Phoenix.LiveComponent

  alias KatotoWeb.LobbyView

  def render(assigns) do
    LobbyView.render("modal/new_lobby.html", assigns)
  end

  def mount(socket) do
    {:ok, socket}
  end
end
