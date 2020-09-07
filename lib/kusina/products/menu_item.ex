defmodule Kusina.Products.MenuItem do
  use Ecto.Schema

  import Ecto.Changeset

  schema "menu_items" do
    field(:name, :string)
    field(:description, :string)
    field(:price, Money.Ecto.Composite.Type)

    belongs_to(:menu_category, Kusina.Products.MenuCategory)
  end

  @required [:name, :menu_category_id]
  @attrs @required ++ [:description]

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
  end
end
