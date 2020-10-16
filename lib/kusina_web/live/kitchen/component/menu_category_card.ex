defmodule KusinaWeb.KitchenLive.Component.MenuCategoryCard do
  @moduledoc false
  use KusinaWeb, :live_component

  alias Kusina.Kitchens
  alias Kusina.Products.MenuCategory
  alias KusinaWeb.KitchenView

  def render(assigns) do
    KitchenView.render("menu_category_card.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, open: false, editing: false)}
  end

  def update(assigns, socket) do
    changeset = MenuCategory.changeset(assigns.menu_category)

    updated_assigns =
      assigns
      |> Map.put(:changeset, changeset)

    {:ok, assign(socket, updated_assigns)}
  end

  def handle_event("update", %{"menu_category" => params}, socket) do
    case Kitchens.update_menu_category(socket.assigns.menu_category, params) do
      {:ok, menu_category} ->
        changeset = MenuCategory.changeset(menu_category)

        {:noreply,
         assign(socket, menu_category: menu_category, changeset: changeset, editing: false)}

      _ ->
        {:noreply, assign(socket, editing: false)}
    end
  end

  def handle_event("delete", _, socket) do
    case Kitchens.delete_menu_category(socket.assigns.menu_category) do
      {:ok, _} ->
        send(self(), :refresh)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end

    {:noreply, socket}
  end

  def handle_event("toggle_editing", _params, socket) do
    toggled_editing = !socket.assigns.editing

    socket =
      if toggled_editing do
        push_event(socket, "focus", %{})
      else
        socket
      end

    {:noreply, assign(socket, editing: toggled_editing)}
  end

  def handle_event("toggle_open", _params, socket) do
    {:noreply, assign(socket, open: !socket.assigns.open)}
  end
end
