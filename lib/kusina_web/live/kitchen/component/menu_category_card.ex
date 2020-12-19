defmodule KusinaWeb.KitchenLive.Component.MenuCategoryCard do
  @moduledoc false
  use KusinaWeb, :live_component

  import KusinaWeb.Helpers.Live

  alias Kusina.Kitchens
  alias Kusina.Products.MenuCategory
  alias Kusina.Products.MenuItem
  alias KusinaWeb.KitchenView

  def render(assigns) do
    KitchenView.render("menu_category_card.html", assigns)
  end

  def mount(socket) do
    socket
    |> assign(open: false, action: :edit)
    |> mount_socket()
  end

  def update(assigns, socket) do
    changeset = MenuCategory.changeset(assigns.menu_category)

    updated_assigns =
      assigns
      |> Map.put(:changeset, changeset)

    {:ok, assign(socket, updated_assigns)}
  end

  def handle_event("create", %{"menu_category" => params}, socket) do
    case Kitchens.create_menu_category(params) do
      {:ok, _menu_category} ->
        send(self(), :refresh)
        {:noreply, push_event(socket, "hide_form", %{form: "menu-category"})}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("update", %{"menu_category" => params}, socket) do
    case Kitchens.update_menu_category(socket.assigns.menu_category, params) do
      {:ok, _menu_category} ->
        send(self(), :refresh)
        {:noreply, assign(socket, action: :show, open: false)}

      _ ->
        {:noreply, assign(socket, action: :show, open: false)}
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

  def handle_event("change_action", %{"action" => action}, socket)
      when action in ["edit", "new"] do
    socket =
      socket
      |> assign(action: String.to_existing_atom(action))
      |> push_event("focus", %{})

    {:noreply, socket}
  end

  def handle_event("change_action", %{"action" => action}, socket) do
    {:noreply, assign(socket, action: String.to_existing_atom(action))}
  end

  def handle_event("toggle_open", _params, socket) do
    {:noreply, assign(socket, open: !socket.assigns.open)}
  end
end
