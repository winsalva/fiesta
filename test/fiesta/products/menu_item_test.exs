defmodule Fiesta.Products.MenuItemTest do
  @moduledoc false
  use Fiesta.DataCase

  alias Fiesta.Products.MenuItem

  describe "changeset/2" do
    setup do
      params = params_with_assocs(:menu_item)

      %{params: params}
    end

    test "returns valid changeset", %{params: params} do
      changeset = MenuItem.changeset(%MenuItem{}, params)
      assert changeset.valid?
    end
  end
end
