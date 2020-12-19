defmodule Kusina.Products.MenuItem do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "menu_items" do
    field(:name, :string)
    field(:description, :string)
    field(:price, Money.Ecto.Composite.Type)
    field(:price_input, :string, virtual: true)

    belongs_to(:menu_category, Kusina.Products.MenuCategory)

    timestamps()
  end

  @required [:name, :menu_category_id, :price_input]
  @attrs @required ++ [:description, :price]

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> validate_change(:price_input, fn :price_input, input ->
      case Money.parse(input, :PHP) do
        {:ok, _} -> []
        :error -> [price_input: "is invalid"]
      end
    end)
    |> convert_to_money(:price_input)
  end

  defp convert_to_money(%{valid?: true} = changeset, field) do
    with {:ok, input} <- fetch_change(changeset, field),
         {:ok, money} <- Money.parse(input, :PHP) do
      put_change(changeset, :price, money)
    else
      _ -> changeset
    end
  end

  defp convert_to_money(changeset, _), do: changeset
end
