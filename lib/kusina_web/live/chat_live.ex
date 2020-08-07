defmodule KusinaWeb.ChatLive do
  use Phoenix.LiveView, container: {:div, class: "flex flex-grow"}

  alias KusinaWeb.ChatView

  def render(assigns) do
    ChatView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
