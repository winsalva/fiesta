defmodule FiestaWeb.Component.MenuSection do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias FiestaWeb.Component.Modal
  alias FiestaWeb.Component.Menu, as: MenuComponent
  alias Fiesta.Products.Menu

  @doc "Kitchen ID for retrieving menu"
  prop kitchen_id, :integer, required: true

  @doc "List of menu"
  data menus, :list, default: []

  @doc "Menu changeset for blank form"
  data changeset, :struct

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-between">
      <ul class="border border-gray border-box divide-y divide-gray">
        <li :for={{ menu <- @menus }}>
          <MenuComponent id={{ menu.id }} menu={{ menu }} />
        </li>
      </ul>

      <a href="#" :on-click={{ "open_modal", target: "#add-menu" }} class="self-center uppercase text-secondary font-semibold">
        Add menu
      </a>

      <Modal id="add-menu">
        <template slot="header">Add menu</template>

        {{ f = form_for @changeset, "#", id: "new-menu", class: "flex flex-col", as: :menu, phx_submit: "create_menu", phx_target: @myself }}
        {{ text_input f, :name, class: "p-2", placeholder: "Your menu name" }}
        {{ error_tag f, :name }}
        <#Raw></form></#Raw>

        <template slot="footer">
          <div class="flex justify-end space-x-2">
            <button type="button" :on-click={{ "close_modal", target: "#add-menu" }}>Cancel</button>
            <button type="submit" class="btn btn-secondary" form="new-menu">Submit</button>
          </div>
        </template>
      </Modal>
    </div>
    """
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    kitchen_id = socket.assigns.kitchen_id
    menus = Products.list_menus(kitchen_id: socket.assigns.kitchen_id)
    changeset = Menu.changeset(%Menu{kitchen_id: kitchen_id})

    {:ok, assign(socket, menus: menus, changeset: changeset)}
  end

  def handle_event("create_menu", %{"menu" => params}, socket) do
    params = Map.put(params, "kitchen_id", socket.assigns.kitchen_id)

    case Products.create_menu(params) do
      {:ok, _menu} ->
        send_update(__MODULE__, id: "menu-section")
        Modal.close("add-menu")
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
