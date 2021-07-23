defmodule FiestaWeb.Component.MenuItem do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias FiestaWeb.Component.MenuItemSection
  alias FiestaWeb.Component.Modal

  @doc "Marks the items as selected"
  prop selected, :boolean, required: true

  @doc "Menu item struct"
  prop menu_item, :struct, required: true

  def render(assigns) do
    ~F"""
    <div class={"flex relative", "border-l-4 border-primary": @selected} id={"menu-item-#{@id}"} :hook={"FeatherIcons", from: Modal} :on-click="show_form">
      <div class="cursor-pointer p-2 flex-grow truncate">
        {@menu_item.name}
      </div>
      <a href="#" class="bg-white absolute right-0 top-2" :on-click="delete_menu_item">
        <i data-feather="trash-2"></i>
      </a>
    </div>
    """
  end

  def handle_event("delete_menu_item", _params, socket) do
    {:ok, _} = Products.delete_menu_item(socket.assigns.menu_item)
    MenuItemSection.refresh()
    send(self(), {:item_selected, nil})

    {:noreply, socket}
  end

  def handle_event("show_form", _, socket) do
    send(self(), {:item_selected, socket.assigns.menu_item})
    {:noreply, socket}
  end
end
