defmodule FiestaWeb.Component.MenuCategory do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.MenuCategory
  alias Fiesta.Repo
  alias FiestaWeb.Component.MenuCategorySection
  alias FiestaWeb.Component.Modal

  @doc "Menu category changeset"
  data changeset, :struct

  @doc "Marks the category as selected"
  prop selected, :boolean, required: true

  @doc "Menu category struct"
  prop menu_category, :struct, required: true

  def render(assigns) do
    ~H"""
    <div class={{ "flex relative", "border-l-4 border-primary": @selected }} id={{ "menu-category-#{@id}" }} :hook={{ "FeatherIcons", from: Modal }}>
      <div href="#" class="cursor-pointer p-2 flex-grow truncate" :on-click="show_items">
        {{ @menu_category.name }}
      </div>

      <div class="bg-white flex absolute right-0 top-2">
        <a href="#" :on-click={{ "open_modal", target: "#edit-menu-category-#{@id}" }}>
          <i data-feather="edit"></i>
        </a>
        <a href="#" :on-click="delete_menu_category">
          <i data-feather="trash-2"></i>
        </a>
      </div>

      <Modal id="edit-menu-category-{{ @id }}">
        <template slot="header">Edit menu category</template>
        {{ f = form_for @changeset, "#", id: "edit-menu-category-#{@id}-form", class: "flex flex-col", as: :menu_category, phx_submit: "update_menu_category", phx_target: @myself }}
        {{ text_input f, :name, class: "p-2", placeholder: "Your menu category" }}
        {{ error_tag f, :name }}
        <#Raw></form></#Raw>
        <template slot="footer">
          <div class="flex justify-end space-x-2">
            <button type="button" :on-click={{ "close_modal", target: "#edit-menu-category-#{@id}" }}>Cancel</button>
            <button type="submit" class="btn btn-secondary" form="edit-menu-category-{{ @id }}-form">Update</button>
          </div>
        </template>
      </Modal>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    changeset = MenuCategory.changeset(socket.assigns.menu_category)

    {:ok, assign(socket, changeset: changeset)}
  end

  def preload(list_of_assigns) do
    menu_categories =
      list_of_assigns
      |> Enum.map(& &1.menu_category)
      |> Repo.preload(:menu, force: true)

    Enum.map(list_of_assigns, fn assigns ->
      preloaded_menu_category = Enum.find(menu_categories, &(&1.id == assigns.id))
      Map.put(assigns, :menu_category, preloaded_menu_category)
    end)
  end

  def handle_event("update_menu_category", %{"menu_category" => params}, socket) do
    case Products.update_menu_category(socket.assigns.menu_category, params) do
      {:ok, menu_category} ->
        Modal.close("edit-menu-category-#{menu_category.id}")
        send_update(__MODULE__, id: socket.assigns.id, menu_category: menu_category)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("delete_menu_category", _, socket) do
    menu_category = socket.assigns.menu_category
    {:ok, _} = Products.delete_menu_category(menu_category)

    send_update(MenuCategorySection,
      id: socket.assigns.menu_category.menu_id,
      menu: menu_category.menu
    )

    {:noreply, socket}
  end

  def handle_event("show_items", _, socket) do
    send(self(), {:category_selected, socket.assigns.id})

    {:noreply, socket}
  end
end
