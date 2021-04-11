defmodule Fiesta.Products do
  @moduledoc """
  Products context
  """
  import Ecto.Query
  alias Fiesta.Repo
  alias Fiesta.Products.Menu
  alias Fiesta.Products.MenuCategory

  def list_menus(params) do
    params = Enum.to_list(params)

    Menu
    |> where(^params)
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
end
