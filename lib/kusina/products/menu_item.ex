defmodule Kusina.Products.MenuItem do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "menu_items" do
    field(:name, :string)
    field(:description, :string)
    field(:price, Money.Ecto.Composite.Type)

    belongs_to(:menu_category, Kusina.Products.MenuCategory)

    timestamps()
  end

  @required [:name, :menu_category_id, :price]
  @attrs @required ++ [:description]

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
  end
end
