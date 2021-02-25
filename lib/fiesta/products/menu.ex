defmodule Fiesta.Products.Menu do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "menus" do
    has_many(:categories, Fiesta.Products.MenuCategory)
    belongs_to(:kitchen, Fiesta.Kitchens.Kitchen)
  end

  @required [:kitchen_id]
  @attrs @required

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> cast_assoc(:categories)
  end
end
