defmodule FiestaWeb.Component.Menu do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.Menu
  alias FiestaWeb.Component.Dropdown
  alias FiestaWeb.Component.MenuCategorySection
  alias FiestaWeb.Component.MenuSection
  alias FiestaWeb.Component.Modal

  @doc "Menu struct"
  prop menu, :struct, required: true

  @doc "Collapse menu categories"
  prop collapse, :boolean, required: true

  @doc "Selected menu category id"
  prop selected_menu_category_id, :integer, required: true

  @doc "Menu changeset"
  data changeset, :struct

  def render(assigns) do
    ~H"""
    <div class="flex flex-col relative" id={{ "menu-#{@id}" }} :hook={{ "FeatherIcons", from: Modal }}>
      <a href="#" class="p-2 flex" :on-click="toggle_categories">
        <div class="flex-grow-0" :show={{ !@collapse }}>
          <i data-feather="chevron-right"></i>
        </div>

        <div class="flex-grow-0" :show={{ @collapse }}>
          <i data-feather="chevron-down"></i>
        </div>

        <div class="flex-grow truncate">
          {{ @menu.name }}
        </div>
      </a>

      <div class="absolute right-0 top-2">
        <Dropdown>
          <template slot="clickable">
            <i data-feather="more-vertical"></i>
          </template>

          <ul>
            <li class="p-2 flex space-x-2 cursor-pointer hover:bg-gray-100"
              :on-click={{ "open_modal", target: "#edit-menu-#{@id}" }} x-on:click="isOpen = false">
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

      <div :show={{ @collapse }}>
        <MenuCategorySection id={{ @menu.id }} menu={{ @menu }} selected_menu_category_id={{ @selected_menu_category_id }} />
      </div>

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
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    changeset = Menu.changeset(socket.assigns.menu)

    {:ok, assign(socket, changeset: changeset)}
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

  def handle_event("toggle_categories", _, %{assigns: %{collapse: true}} = socket) do
    send(self(), {:category_toggled, nil})

    {:noreply, socket}
  end

  def handle_event("toggle_categories", _, %{assigns: %{collapse: false}} = socket) do
    send(self(), {:category_toggled, socket.assigns.id})

    {:noreply, socket}
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
