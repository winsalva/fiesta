defmodule Fiesta.Products do
  @moduledoc """
  Products context
  """
  import Ecto.Query
  alias Fiesta.Products.Menu
  alias Fiesta.Products.MenuCategory
  alias Fiesta.Products.MenuItem
  alias Fiesta.Repo

  def list_menus(params) do
    params = Enum.to_list(params)

    Menu
    |> where(^params)
    |> Repo.all()
  end

  def list_menu_items(params) do
    {order_by, params} =
      params
      |> Enum.to_list()
      |> Keyword.pop(:order_by, [])

    MenuItem
    |> where(^params)
    |> order_by(^order_by)
    |> Repo.all()
  end

  def create_menu(params) do
    %Menu{}
    |> Menu.changeset(params)
    |> Repo.insert()
  end

  def update_menu(menu, params) do
    menu
    |> Menu.changeset(params)
    |> Repo.update()
  end

  def delete_menu(menu) do
    menu
    |> Menu.changeset()
    |> Repo.delete()
  end

  def create_menu_category(params) do
    %MenuCategory{}
    |> MenuCategory.changeset(params)
    |> Repo.insert()
  end

  def update_menu_category(menu_category, params) do
    menu_category
    |> MenuCategory.changeset(params)
    |> Repo.update()
  end

  def delete_menu_category(menu_category) do
    menu_category
    |> MenuCategory.changeset()
    |> Repo.delete()
  end

  def delete_menu_item(menu_item) do
    menu_item
    |> MenuItem.changeset()
    |> Repo.delete()
  end

  def get_menu_item(id) when is_nil(id) or id == "" do
    nil
  end

  def get_menu_item(id) do
    Repo.get(MenuItem, id)
  end

  def upsert_menu_item(%{"id" => id} = params) do
    id
    |> get_menu_item()
    |> do_upsert_menu_item(params)
  end

  def upsert_menu_item(%{id: id} = params) do
    id
    |> get_menu_item()
    |> do_upsert_menu_item(params)
  end

  defp do_upsert_menu_item(menu_item, params) do
    menu_item
    |> case do
      nil -> %MenuItem{}
      menu_item -> menu_item
    end
    |> MenuItem.changeset(params)
    |> Repo.insert_or_update()
  end
end
