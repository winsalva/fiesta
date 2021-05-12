defmodule FiestaWeb.Component.MenuCategorySection do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.MenuCategory
  alias Fiesta.Repo
  alias FiestaWeb.Component.MenuCategory, as: MenuCategoryComponent
  alias FiestaWeb.Component.Modal

  @doc "Menu struct"
  prop menu, :struct, required: true

  @doc "Selected menu category id"
  prop selected_menu_category_id, :integer, required: true

  @doc "Menu category changeset"
  data changeset, :struct

  def render(assigns) do
    ~H"""
    <div>
      <ul class="border-box divide-y divide-gray-300">
        <li :for={{ menu_category <- @menu.categories }}>
          <MenuCategoryComponent id={{ menu_category.id }} menu_category={{ menu_category }} selected={{ menu_category.id == @selected_menu_category_id }} />
        </li>
        <li class="p-2">
          <a href="#" :on-click={{ "open_modal", target: "#add-menu-#{@menu.id}-category" }} class="self-center uppercase text-secondary font-semibold">
            Add category
          </a>
        </li>
      </ul>

      <Modal id="add-menu-{{ @menu.id }}-category">
        <template slot="header">Add category</template>

        {{ f = form_for MenuCategory.changeset(%MenuCategory{}), "#", id: "new-menu-category", class: "flex flex-col", as: :menu_category, phx_submit: "create_menu_category", phx_target: @myself }}
        {{ text_input f, :name, class: "p-2", placeholder: "Your menu name" }}
        {{ error_tag f, :name }}
        <#Raw></form></#Raw>

        <template slot="footer">
          <div class="flex justify-end space-x-2">
            <button type="button" :on-click={{ "close_modal", target: "#add-menu-#{@menu.id}-category" }}>Cancel</button>
            <button type="submit" class="btn btn-secondary" form="new-menu-category">Submit</button>
          </div>
        </template>
      </Modal>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    changeset = MenuCategory.changeset(%MenuCategory{})

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

  def handle_event("create_menu_category", %{"menu_category" => params}, socket) do
    params
    |> Map.put("menu_id", socket.assigns.menu.id)
    |> Products.create_menu_category()
    |> case do
      {:ok, _menu_category} ->
        send_update(__MODULE__, id: socket.assigns.id, menu: socket.assigns.menu)
        Modal.close("add-menu-#{socket.assigns.menu.id}-category")
        {:noreply, socket}

      {:error, changeset} ->
        send_update(Modal, id: "add-menu-#{socket.assigns.menu.id}-category", changeset: changeset)

        {:noreply, socket}
    end
  end
end
