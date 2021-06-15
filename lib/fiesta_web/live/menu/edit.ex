defmodule FiestaWeb.MenuLive.Edit do
  @moduledoc false
  use FiestaWeb, :live
  import Surface

  alias Fiesta.Accounts
  alias Fiesta.Repo
  alias FiestaWeb.Component.MenuItemForm
  alias FiestaWeb.Component.MenuItemSection
  alias FiestaWeb.Component.MenuSection

  @doc "Selected menu id "
  data selected_menu_id, :integer, default: nil

  @doc "Selected menu category id"
  data selected_menu_category_id, :integer, default: nil

  @doc "Selected menu item struct"
  data selected_menu_item, :struct, default: nil

  def render(assigns) do
    ~H"""
    <div class="p-6 flex flex-col">
      <div class="bg-white rounded-md p-6">
        <div>Craft your menu</div>
        <div class="flex flex-col lg:flex-row mt-4 w-full">
          <!-- Add menu -->
          <div class="flex flex-col w-full lg:w-1/4">
            <MenuSection id="menu-section" kitchen_id={{ @current_user.kitchen.id }} selected_menu_id={{ @selected_menu_id }} selected_menu_category_id={{ @selected_menu_category_id }} />
          </div>

          <!-- Add item -->
          <div class="flex flex-col w-full lg:w-1/4">
            <MenuItemSection id="menu-item-section" selected_menu_category_id={{ @selected_menu_category_id }} selected_menu_item_id={{ @selected_menu_item && @selected_menu_item.id }} />
          </div>

          <!-- Item description -->
          <div class="flex flex-col w-full lg:w-1/2">
            <MenuItemForm id="menu-item-form" menu_item={{ @selected_menu_item }} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_, %{"user_id" => user_id}, socket) do
    user =
      user_id
      |> Accounts.get_user()
      |> Repo.preload(:kitchen)

    {:ok, assign(socket, current_user: user)}
  end

  def handle_info({:category_toggled, menu_component_id}, socket) do
    {:noreply,
     assign(socket,
       selected_menu_id: menu_component_id,
       selected_menu_category_id: nil,
       selected_menu_item: nil
     )}
  end

  def handle_info({:category_selected, menu_category_component_id}, socket) do
    {:noreply,
     assign(socket,
       selected_menu_category_id: menu_category_component_id,
       selected_menu_item: nil
     )}
  end

  def handle_info({:item_selected, menu_item_struct}, socket) do
    {:noreply, assign(socket, selected_menu_item: menu_item_struct)}
  end
end
