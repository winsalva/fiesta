defmodule KatotoWeb.LobbyLive do
  use Phoenix.LiveView, container: {:div, class: "flex-grow"}
  alias KatotoWeb.Router.Helpers, as: Routes

  alias Katoto.Chat
  alias Katoto.Chat.Lobby
  alias KatotoWeb.ChatLive
  alias KatotoWeb.LobbyView

  def render(assigns) do
    LobbyView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    changeset = Lobby.changeset(%Lobby{})
    {:ok, assign(socket, changeset: changeset, show_modal: nil)}
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

  def handle_event("open_modal", %{"modal" => modal}, socket) do
    {:noreply, assign(socket, show_modal: String.to_atom(modal))}
  end

  def handle_event("modal_keydown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, show_modal: nil)}
  end

  def handle_event("modal_keydown", _, socket), do: {:noreply, socket}

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: nil)}
  end
end
