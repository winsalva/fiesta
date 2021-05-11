defmodule Fiesta.Products.MenuItem do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Fiesta.CustomType.MultiCurrencyPrice

  schema "menu_items" do
    field(:name, :string)
    field(:description, :string)
    field(:price, MultiCurrencyPrice)
    field(:tax, :decimal)
    field(:visibility, Ecto.Enum, values: [:active, :inactive])

    belongs_to(:category, Fiesta.Products.MenuCategory, foreign_key: :menu_category_id)

    timestamps()
  end

  @required [:name, :menu_category_id, :tax, :visibility]
  @attrs @required ++ [:description, :price]

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
  end
end
