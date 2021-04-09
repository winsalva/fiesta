defmodule Fiesta.Products.Menu do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "menus" do
    field(:name, :string)

    has_many(:categories, Fiesta.Products.MenuCategory)
    belongs_to(:kitchen, Fiesta.Kitchens.Kitchen)

    timestamps()
  end

  @required [:kitchen_id, :name]
  @attrs @required

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> cast_assoc(:categories)
  end
end
