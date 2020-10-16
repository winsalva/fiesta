defmodule Kusina.Products.Menu do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "menus" do
    has_many(:categories, Kusina.Products.MenuCategory)
    belongs_to(:kitchen, Kusina.Kitchens.Kitchen)

    timestamps()
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
