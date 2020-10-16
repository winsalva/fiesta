defmodule KusinaWeb.KitchenLive.Form do
  @moduledoc false
  use KusinaWeb, :live

  import KusinaWeb.Helpers.Live

  alias Kusina.Kitchens
  alias Kusina.Products.MenuCategory
  alias Kusina.Repo
  alias KusinaWeb.KitchenView

  def render(assigns) do
    KitchenView.render("form.html", assigns)
  end

  def mount(%{"id" => id}, _, socket) do
    id
    |> Kitchens.get_kitchen()
    |> Repo.preload(menu: :categories)
    |> case do
      nil ->
        unauthorize(socket)

      kitchen ->
        assign(socket,
          kitchen: kitchen,
          menu_category_changeset: MenuCategory.changeset(%MenuCategory{}, %{})
        )
    end
    |> assign(tab: "menu")
    |> mount_socket()
  end

  def handle_event("change_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, tab: tab)}
  end

  def handle_event("create_menu_category", %{"menu_category" => params}, socket) do
    case Kitchens.create_menu_category(params) do
      {:ok, _menu_category} ->
        kitchen = Repo.preload(socket.assigns.kitchen, [menu: :categories], force: true)
        {:noreply, assign(socket, kitchen: kitchen)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(:refresh, socket) do
    kitchen = Repo.preload(socket.assigns.kitchen, [menu: :categories], force: true)
    {:noreply, assign(socket, kitchen: kitchen)}
  end
end
