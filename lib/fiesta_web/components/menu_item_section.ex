defmodule FiestaWeb.Component.MenuItemSection do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Repo

  @doc "Menu category struct"
  prop menu_category, :struct, default: nil

  @doc "Menu item changeset"
  data changeset, :struct

  def render(assigns) do
    ~H"""
    <div class="flex flex-col" :show={{ not is_nil(@menu_category) }}>
      <ul class="border border-gray border-box divide-y divide-gray" :if={{ @menu_category }}>
        <li :for={{ item <- @menu_category.items }}>
            {{ item.name }}
        </li>
      </ul>

      <a href="#" :on-click={{ "open_modal", target: "#add-menu-item" }}
        class="justify-self-end self-center uppercase text-secondary font-semibold"
        :if={{ @menu_category }}>
        Add item
      </a>
    </div>
    """
  end

  def update(assigns, socket) do
    IO.inspect(assigns, label: "ITEM_SECTION_ASSIGNS")
    socket = assign(socket, assigns)

    {:ok, update(socket, :menu_category, &Repo.preload(&1, :items))}
  end
end
