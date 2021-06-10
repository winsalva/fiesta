defmodule Fiesta.Kitchens.Kitchen do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "kitchens" do
    field(:name, :string)
    field(:description, :string)

    has_many(:menus, Fiesta.Products.Menu)
    belongs_to(:owner, Fiesta.Accounts.User, foreign_key: :owner_id)

    timestamps()
  end

  @required [:name]
  @attrs @required ++ [:description, :owner_id]

  def changeset(kitchen_or_changeset, attrs \\ %{}) do
    kitchen_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> assoc_constraint(:owner)
    |> unique_constraint(:owner_id, name: :kitchens_owner_id_index)
    |> cast_assoc(:menus)
  end
end
