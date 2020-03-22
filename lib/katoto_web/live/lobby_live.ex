defmodule KatotoWeb.LobbyLive do
  use KatotoWeb, :live

  alias Katoto.Chat
  alias Katoto.Chat.Lobby
  alias KatotoWeb.ChatLive
  alias KatotoWeb.LobbyView

  def render(assigns) do
    LobbyView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    changeset = Lobby.changeset(%Lobby{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"lobby" => params}, socket) do
    changeset =
      %Lobby{}
      |> Lobby.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"lobby" => params}, socket) do
    case Chat.create_lobby(params) do
      {:ok, lobby} ->
        {:noreply, redirect(socket, to: Routes.live_path(socket, ChatLive, lobby.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
