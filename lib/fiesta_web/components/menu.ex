defmodule FiestaWeb.Component.Menu do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.Menu
  alias Fiesta.Products.MenuCategory
  alias Fiesta.Repo
  alias FiestaWeb.Component.Dropdown
  alias FiestaWeb.Component.MenuCategory, as: MenuCategoryComponent
  alias FiestaWeb.Component.MenuSection
  alias FiestaWeb.Component.Modal

  @doc "Menu struct"
  prop menu, :struct, required: true

  @doc "Menu changeset"
  data changeset, :struct

  @doc "Collapse menu categories"
  data show_categories, :boolean, default: false

  @doc "Left part"
  slot left

  @doc "Middle part usually the text"
  slot default

  @doc "Right part"
  slot right

  def render(assigns) do
    ~H"""
    <div class="flex flex-col relative" id={{ "menu-#{@id}" }} :hook={{ "FeatherIcons", from: Modal }}>
      <div class="p-2 flex" :on-click="toggle_categories">
        <div class="flex-grow-0" :show={{ !@show_categories }}>
          <i data-feather="chevron-right"></i>
        </div>

        <div class="flex-grow-0" :show={{ @show_categories }}>
          <i data-feather="chevron-down"></i>
        </div>

        <div class="flex-grow truncate">
          {{ @menu.name }}
        </div>
      </div>

      <div class="absolute right-0 top-2">
        <Dropdown>
          <template slot="clickable">
            <i data-feather="more-vertical"></i>
          </template>

          <ul>
            <li class="p-2 flex space-x-2 cursor-pointer hover:bg-gray-100"
              :on-click={{ "open_modal", target: "#edit-menu-#{@id}" }}>
              <i data-feather="edit"></i>
              <span> Edit </span>
            </li>
            <li class="p-2 flex space-x-2 cursor-pointer hover:bg-gray-100"
              :on-click={{ "delete_menu", target: @myself }}>
              <i data-feather="trash-2"></i>
              <span> Delete </span>
            </li>
          </ul>
        </Dropdown>
      </div>

      <ul class="border-box divide-y divide-gray" :show={{ @show_categories }}>
        <li :for={{ menu_category <- @menu.categories }}>
          <MenuCategoryComponent id={{ menu_category.id }} menu_category={{ menu_category }} />
        </li>
        <li class="p-2">
          <a href="#" :on-click={{ "open_modal", target: "#add-menu-#{@id}-category" }} class="self-center uppercase text-secondary font-semibold">
            Add category
          </a>
        </li>
      </ul>

      <Modal id="edit-menu-{{ @id }}">
        <template slot="header">Edit menu</template>

        {{ f = form_for @changeset, "#", id: "edit-menu-#{@id}-form", class: "flex flex-col", as: :menu, phx_submit: "update_menu", phx_target: @myself }}
        {{ text_input f, :name, class: "p-2", placeholder: "Your menu name" }}
        {{ error_tag f, :name }}
        <#Raw></form></#Raw>

        <template slot="footer">
          <div class="flex justify-end space-x-2">
            <button type="button" :on-click={{ "close_modal", target: "#edit-menu-#{@id}" }}>Cancel</button>
            <button type="submit" class="btn btn-secondary" form="edit-menu-{{ @id }}-form">Update</button>
          </div>
        </template>
      </Modal>

      <Modal id="add-menu-{{ @id }}-category">
        <template slot="header">Add category</template>

        {{ f = form_for MenuCategory.changeset(%MenuCategory{}), "#", id: "new-menu-category", class: "flex flex-col", as: :menu_category, phx_submit: "create_menu_category", phx_target: @myself }}
        {{ text_input f, :name, class: "p-2", placeholder: "Your menu name" }}
        {{ error_tag f, :name }}
        <#Raw></form></#Raw>

        <template slot="footer">
          <div class="flex justify-end space-x-2">
            <button type="button" :on-click={{ "close_modal", target: "#add-menu-#{@id}-category" }}>Cancel</button>
            <button type="submit" class="btn btn-secondary" form="new-menu-category">Submit</button>
          </div>
        </template>
      </Modal>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    changeset = Menu.changeset(socket.assigns.menu)

    {:ok, assign(socket, changeset: changeset)}
  end

  def preload(list_of_assigns) do
    menus =
      list_of_assigns
      |> Enum.map(& &1.menu)
      |> Repo.preload(:categories, force: true)

    Enum.map(list_of_assigns, fn assigns ->
      preloaded_menu = Enum.find(menus, &(&1.id == assigns.id))
      Map.put(assigns, :menu, preloaded_menu)
    end)
  end

  def handle_event("update_menu", %{"menu" => params}, socket) do
    case Products.update_menu(socket.assigns.menu, params) do
      {:ok, menu} ->
        Modal.close("edit-menu-#{menu.id}")
        send_update(__MODULE__, id: menu.id, menu: menu)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("delete_menu", _, socket) do
    {:ok, _} = Products.delete_menu(socket.assigns.menu)
    send_update(MenuSection, id: "menu-section")
    {:noreply, socket}
  end

  def handle_event("toggle_categories", _, socket) do
    {:noreply, update(socket, :show_categories, &(!&1))}
  end

  def handle_event("create_menu_category", %{"menu_category" => params}, socket) do
    params
    |> Map.put("menu_id", socket.assigns.menu.id)
    |> Products.create_menu_category()
    |> case do
      {:ok, _menu_category} ->
        send_update(__MODULE__, id: socket.assigns.id, menu: socket.assigns.menu)
        Modal.close("add-menu-#{socket.assigns.id}-category")
        {:noreply, socket}

      {:error, changeset} ->
        send_update(Modal, id: "add-menu-#{socket.assigns.id}-category", changeset: changeset)
        {:noreply, socket}
    end
  end
end
