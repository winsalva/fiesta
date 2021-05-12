defmodule FiestaWeb.Component.MenuItemForm do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.MenuItem
  alias FiestaWeb.Component.MenuItemSection

  @doc "Menu item struct"
  prop menu_item, :struct, required: true

  @doc "Menu item changeset"
  data changeset, :struct

  def render(assigns) do
    ~H"""
    <div class="flex-grow flex flex-col space-y-2" :show={{ not is_nil(@menu_item) }}>
      <div :if={{ @menu_item }}>
        {{ f = form_for @changeset, "#",
          id: @id,
          class: "border border-gray-300 border-box grid p-7 gap-3 text-xs grid-cols-3",
          phx_submit: "upsert_menu_item",
          phx_target: @myself,
          phx_hook: "FiestaWeb.Component.MenuItemForm#MaskPrice"
        }}
        <div class="flex flex-col space-y-2 col-span-3">
          {{ label f, :name }}
          {{ text_input f, :name, class: "p-2" }}
          {{ error_tag f, :name }}
        </div>
        <div class="flex flex-col space-y-2 col-span-3">
          {{ label f, :description }}
          {{ textarea f, :description, class: "p-2 resize-none" }}
          {{ error_tag f, :description }}
        </div>
        {{ hidden_input f, :id }}
        {{ hidden_input f, :menu_category_id }}
        <div class="flex flex-col space-y-2 col-span-1">
          {{ label f, :price }}
          {{ price_input f, :price, class: "p-2", name: "menu_item[price][amount]" }}
          {{ error_tag f, :price }}
          {{ hidden_input f, :price, name: "menu_item[price][currency]", value: "PHP" }}
        </div>
        <div class="flex flex-col space-y-2 col-span-1">
          {{ label f, :tax, "Tax %" }}
          {{ text_input f, :tax, class: "p-2 price-input" }}
          {{ error_tag f, :tax }}
        </div>
        <div class="flex flex-col space-y-2 col-span-1">
          {{ label f, :visibility, "Item visibility" }}
          {{ select f, :visibility, [:active, :inactive], class: "p-2" }}
          {{ error_tag f, :visibility }}
        </div>
        <#Raw></form></#Raw>
      </div>

      <button type="submit" class="btn btn-secondary" form="{{ @id }}" :if={{ @menu_item }}> Submit changes </button>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    menu_item = socket.assigns.menu_item
    changeset = menu_item && MenuItem.changeset(menu_item)

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("upsert_menu_item", %{"menu_item" => params}, socket) do
    case Products.upsert_menu_item(params) do
      {:ok, _menu_item} ->
        MenuItemSection.refresh()
        send(self(), {:item_selected, nil})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
