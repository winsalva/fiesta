defmodule KusinaWeb.KitchenLive.Form do
  @moduledoc false
  use KusinaWeb, :live

  import Ecto.Query
  import KusinaWeb.Helpers.Live

  alias Kusina.Kitchens
  alias Kusina.Products.MenuCategory
  alias Kusina.Products.MenuItem
  alias Kusina.Repo
  alias KusinaWeb.KitchenView

  def render(assigns) do
    KitchenView.render("form.html", assigns)
  end

  def mount(%{"id" => id}, _, socket) do
    id
    |> Kitchens.get_kitchen()
    |> force_preload(false)
    |> case do
      nil -> unauthorize(socket)
      kitchen -> assign(socket, kitchen: kitchen)
    end
    |> assign(tab: "menu")
    |> mount_socket()
  end

  def handle_event("change_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, tab: tab)}
  end

  def handle_info(:refresh, socket) do
    {:noreply, assign(socket, kitchen: force_preload(socket.assigns.kitchen, true))}
  end

  defp force_preload(kitchen, force?) do
    preloads = [
      menu: [
        categories: {order_by_inserted_at(MenuCategory), [items: order_by_inserted_at(MenuItem)]}
      ]
    ]

    Repo.preload(kitchen, preloads, force: force?)
  end

  defp order_by_inserted_at(query), do: order_by(query, desc: :inserted_at)
end
