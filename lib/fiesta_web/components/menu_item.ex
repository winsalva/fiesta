defmodule FiestaWeb.Component.MenuItem do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Repo
  alias FiestaWeb.Component.MenuItemSection

  @doc "Menu item struct"
  prop menu_item, :struct, required: true

  def render(assigns) do
    ~H"""
    <div class="flex p-2">
      <div class="flex-grow truncate">
        {{ @menu_item.name }}
      </div>
      <a href="#" class="justify-self-end flex-grow-0" :on-click="delete_menu_item">
        <i data-feather="trash-2"></i>
      </a>
    </div>
    """
  end

  def preload(list_of_assigns) do
    menu_items =
      list_of_assigns
      |> Enum.map(& &1.menu_item)
      |> Repo.preload(:menu_category, force: true)

    Enum.map(list_of_assigns, fn assigns ->
      preloaded_menu_item = Enum.find(menu_items, &(&1.id == assigns.id))
      Map.put(assigns, :menu_item, preloaded_menu_item)
    end)
  end

  def handle_event("delete_menu_item", _params, socket) do
    {:ok, _} = Products.delete_menu_item(socket.assigns.menu_item)

    send_update(MenuItemSection,
      id: socket.assigns.menu_item.category_id,
      menu_category: socket.assigns.menu_item.category
    )

    {:noreply, socket}
  end
end
