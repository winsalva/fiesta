defmodule Kusina.KitchensTest do
  use Kusina.DataCase, async: true

  alias Kusina.Kitchens

  describe "create_kitchen/1" do
    setup do
      {:ok, params: params_for(:kitchen)}
    end

    test "creates a kitchen", %{params: params} do
      owner = insert(:user)
      params = Map.put(params, :owner_id, owner.id)
      {:ok, kitchen} = Kitchens.create_kitchen(params)

      assert kitchen.id
      assert kitchen.name
      assert kitchen.description
      assert kitchen.owner_id
    end
  end

  describe "update_kitchen/2" do
    setup do
      {:ok, kitchen: insert(:kitchen)}
    end

    test "updates a kitchen", %{kitchen: kitchen} do
      params = params_for(:kitchen)

      {:ok, updated_kitchen} = Kitchens.update_kitchen(kitchen, params)

      assert updated_kitchen.name == params.name
      assert updated_kitchen.description == params.description
    end
  end

  describe "get_kitchen/1" do
    setup do
      {:ok, kitchen: insert(:kitchen)}
    end

    test "retrieves a kitchen", %{kitchen: kitchen} do
      assert Kitchens.get_kitchen(kitchen.id)
    end

    test "returns nil if kitchen is not found", %{kitchen: kitchen} do
      Repo.delete(kitchen)
      refute Kitchens.get_kitchen(kitchen.id)
    end
  end
end
