defmodule FiestaWeb.Component.MenuItemSection do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.MenuItem
  alias FiestaWeb.Component.MenuItem, as: MenuItemComponent

  @doc "Selected menu category id"
  prop selected_menu_category_id, :integer, required: true

  @doc "Selected menu item id"
  prop selected_menu_item_id, :integer, required: true

  @doc "Menu item changeset"
  data changeset, :struct

  @doc "Menu category retrieved from selected menu category"
  data items, :list, default: []

  def render(assigns) do
    ~F"""
    <div class="flex-grow flex flex-col" :show={not is_nil(@selected_menu_category_id)}>
      <ul class="border border-gray-300 border-box divide-y divide-gray-300" :if={@selected_menu_category_id && @items != []}>
        <li :for={item <- @items}>
          <MenuItemComponent id={item.id} menu_item={item} selected={item.id == @selected_menu_item_id} />
        </li>
      </ul>

      <a href="#" :on-click="add_menu_item"
        class="mt-auto self-center uppercase text-secondary font-semibold p-2"
        :if={@selected_menu_category_id}>
        Add item
      </a>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    items =
      case socket.assigns.selected_menu_category_id do
        nil ->
          []

        menu_category_id ->
          Products.list_menu_items(
            menu_category_id: menu_category_id,
            order_by: [asc: :inserted_at]
          )
      end

    {:ok, assign(socket, items: items)}
  end

  def handle_event("add_menu_item", _, socket) do
    send(
      self(),
      {:item_selected, %MenuItem{menu_category_id: socket.assigns.selected_menu_category_id}}
    )

    {:noreply, socket}
  end

  def refresh, do: send_update(__MODULE__, id: "menu-item-section")
end
