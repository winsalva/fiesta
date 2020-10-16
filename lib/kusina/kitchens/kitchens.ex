defmodule Kusina.Kitchens do
  @moduledoc """
  Kitchens Context
  """

  alias Ecto.Multi
  alias Kusina.Kitchens.Kitchen
  alias Kusina.Products.Menu
  alias Kusina.Products.MenuCategory
  alias Kusina.Repo

  def create_kitchen(%Ecto.Changeset{} = changeset), do: Repo.insert(changeset)

  def create_kitchen(params) do
    %Kitchen{}
    |> Kitchen.changeset(params)
    |> Repo.insert()
  end

  def setup_kitchen(%Ecto.Changeset{} = changeset) do
    Multi.new()
    |> Multi.insert(:kitchen, changeset)
    |> Multi.insert(:menu, fn %{kitchen: kitchen} ->
      Menu.changeset(%Menu{}, %{kitchen_id: kitchen.id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{kitchen: kitchen}} -> {:ok, kitchen}
      {:error, _multi_name, changeset, _changes_so_far} -> {:error, changeset}
    end
  end

  def get_kitchen(id), do: Repo.get(Kitchen, id)

  def update_kitchen(kitchen, params) do
    kitchen
    |> Kitchen.changeset(params)
    |> Repo.update()
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

  def delete_menu_category(%MenuCategory{} = menu_category) do
    menu_category
    |> MenuCategory.changeset()
    |> Repo.delete()
  end

  def change_kitchen(kitchen, params \\ %{})
  def change_kitchen(nil, params), do: Kitchen.changeset(%Kitchen{}, params)
  def change_kitchen(kitchen, params), do: Kitchen.changeset(kitchen, params)
end
