defmodule KusinaWeb.KitchenLive.Component.MenuItemCard do
  @moduledoc false
  use KusinaWeb, :live_component

  alias Kusina.Kitchens
  alias Kusina.Products.MenuItem
  alias KusinaWeb.KitchenView

  def render(assigns) do
    KitchenView.render("menu_item_card.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, action: :edit)}
  end

  def update(assigns, socket) do
    changeset = MenuItem.changeset(assigns.menu_item)

    updated_assigns =
      assigns
      |> Map.put(:changeset, changeset)

    {:ok, assign(socket, updated_assigns)}
  end

  def handle_event("create", %{"menu_item" => params}, socket) do
    case Kitchens.create_menu_item(params) do
      {:ok, _menu_item} ->
        send(self(), :refresh)
        {:noreply, push_event(socket, "hide_form", %{form: "menu-item"})}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("change_action", %{"action" => action}, socket)
      when action in ["edit", "new"] do
    socket =
      socket
      |> assign(action: String.to_existing_atom(action))
      |> push_event("focus", %{})

    {:noreply, socket}
  end
end
