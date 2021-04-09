defmodule Fiesta.Kitchens do
  @moduledoc """
  Kitchens Context
  """

  alias Fiesta.Kitchens.Kitchen
  alias Fiesta.Repo

  def create_kitchen(%Ecto.Changeset{} = changeset), do: Repo.insert(changeset)

  def create_kitchen(params) do
    %Kitchen{}
    |> Kitchen.changeset(params)
    |> Repo.insert()
  end

  def get_kitchen(id), do: Repo.get(Kitchen, id)

  def get_kitchen_by(clause) do
    Repo.get_by(Kitchen, clause)
  end

  def update_kitchen(kitchen, params) do
    kitchen
    |> Kitchen.changeset(params)
    |> Repo.update()
  end

  def change_kitchen(kitchen, params \\ %{})
  def change_kitchen(nil, params), do: Kitchen.changeset(%Kitchen{}, params)
  def change_kitchen(kitchen, params), do: Kitchen.changeset(kitchen, params)
end
