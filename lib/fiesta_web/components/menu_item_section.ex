defmodule FiestaWeb.Component.MenuItemSection do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products.MenuItem
  alias Fiesta.Repo
  alias FiestaWeb.Component.MenuItem, as: MenuItemComponent
  alias FiestaWeb.Component.MenuItemForm

  @doc "Menu category struct"
  prop menu_category, :struct, default: nil

  @doc "Menu item changeset"
  data changeset, :struct

  def render(assigns) do
    ~H"""
    <div class="flex-grow flex flex-col" :show={{ not is_nil(@menu_category) }}>
      <ul class="border border-gray border-box divide-y divide-gray" :if={{ @menu_category && @menu_category.items != [] }}>
        <li :for={{ item <- @menu_category.items }}>
          <MenuItemComponent id={{ item.id }} menu_item={{ item }} />
        </li>
      </ul>

      <a href="#" :on-click="add_menu_item"
        class="mt-auto self-center uppercase text-secondary font-semibold p-2"
        :if={{ @menu_category }}>
        Add item
      </a>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    {:ok, update(socket, :menu_category, &Repo.preload(&1, :items, force: true))}
  end

  def handle_event("add_menu_item", _, socket) do
    send_update(MenuItemForm,
      id: "menu-item-form",
      menu_item: %MenuItem{menu_category_id: socket.assigns.menu_category.id}
    )

    {:noreply, socket}
  end
end
