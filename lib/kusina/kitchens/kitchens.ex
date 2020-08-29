defmodule Kusina.Kitchens do
  @moduledoc """
  Kitchens Context
  """

  alias Kusina.Kitchens.Kitchen
  alias Kusina.Repo

  def create_kitchen(params) do
    %Kitchen{}
    |> Kitchen.changeset(params)
    |> Repo.insert()
  end

  def get_kitchen(id), do: Repo.get(Kitchen, id)

  def update_kitchen(kitchen, params) do
    kitchen
    |> Kitchen.changeset(params)
    |> Repo.update()
  end

  def change_kitchen(kitchen, params \\ %{})
  def change_kitchen(nil, params), do: Kitchen.changeset(%Kitchen{}, params)
  def change_kitchen(kitchen, params), do: Kitchen.changeset(kitchen, params)
end
