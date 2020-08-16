defmodule Kusina.Kitchens.Kitchen do
  use Ecto.Schema

  import Ecto.Changeset

  schema "kitchens" do
    field(:name, :string)
    field(:description, :string)

    belongs_to(:owner, Kusina.Users.User)
  end

  @required [:name, :description, :owner_id]
  @attrs @required

  def changeset(kitchen_or_changeset, attrs \\ %{}) do
    kitchen_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> assoc_constraint(:owner)
    |> unique_constraint(:owner_id, name: :kitchens_owner_id_index)
  end
end
