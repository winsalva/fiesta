defmodule Fiesta.Products do
  @moduledoc """
  Products context
  """
  import Ecto.Query
  alias Fiesta.Repo
  alias Fiesta.Products.Menu

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
end
