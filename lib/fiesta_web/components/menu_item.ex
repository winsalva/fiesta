defmodule FiestaWeb.Component.MenuItem do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias FiestaWeb.Component.MenuItemSection
  alias FiestaWeb.Component.MenuItemForm
  alias FiestaWeb.Component.Modal

  @doc "Menu item struct"
  prop menu_item, :struct, required: true

  def render(assigns) do
    ~H"""
    <div class="flex p-2" id={{ "menu-item-#{@id}" }} :hook={{ "FeatherIcons", from: Modal }} :on-click="show_form">
      <div class="flex-grow truncate">
        {{ @menu_item.name }}
      </div>
      <a href="#" class="justify-self-end flex-grow-0" :on-click="delete_menu_item">
        <i data-feather="trash-2"></i>
      </a>
    </div>
    """
  end

  def handle_event("delete_menu_item", _params, socket) do
    {:ok, _} = Products.delete_menu_item(socket.assigns.menu_item)
    send_update(MenuItemSection, id: "menu-item-section")

    {:noreply, socket}
  end

  def handle_event("show_form", _, socket) do
    send_update(MenuItemForm, id: "menu-item-form", menu_item: socket.assigns.menu_item)

    {:noreply, socket}
  end
end
