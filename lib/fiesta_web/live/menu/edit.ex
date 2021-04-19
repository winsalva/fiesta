defmodule FiestaWeb.MenuLive.Edit do
  @moduledoc false
  use FiestaWeb, :live
  import Surface

  alias FiestaWeb.Component.MenuSection
  alias FiestaWeb.Component.MenuItemSection
  alias FiestaWeb.Component.MenuItemForm
  alias Fiesta.Users
  alias Fiesta.Repo

  def render(assigns) do
    ~H"""
    <div class="p-6 flex flex-col">
      <div class="bg-white rounded-md p-6">
        <div>Craft your menu</div>
        <div class="flex mt-4 w-full">
          <!-- Add menu -->
          <div class="flex flex-col w-full lg:w-1/4">
            <MenuSection id="menu-section" kitchen_id={{ @current_user.kitchen.id }} />
          </div>

          <!-- Add item -->
          <div class="flex flex-col w-full lg:w-1/4">
            <MenuItemSection id="menu-item-section" />
          </div>

          <!-- Item description -->
          <div class="flex flex-col w-full lg:w-1/2">
            <MenuItemForm id="menu-item-form" />
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_, %{"user_id" => user_id}, socket) do
    user =
      [id: user_id]
      |> Users.get_by()
      |> Repo.preload(:kitchen)

    {:ok, assign(socket, current_user: user)}
  end
end
