defmodule Fiesta.Kitchens.KitchenTest do
  use Fiesta.DataCase, async: true

  alias Fiesta.Kitchens.Kitchen
  alias Fiesta.Repo

  describe "changeset/2" do
    setup do
      owner = insert(:user)

      params =
        :kitchen
        |> params_for()
        |> Map.take([:name, :description])
        |> Map.put(:owner_id, owner.id)

      {:ok, params: params}
    end

    test "valid changeset", %{params: params} do
      changeset = Kitchen.changeset(%Kitchen{}, params)
      assert changeset.valid?
    end

    test "invalid changeset if missing required attr", %{params: params} do
      params = Map.drop(params, [:name])
      changeset = Kitchen.changeset(%Kitchen{}, params)

      refute changeset.valid?
    end

    test "invalid changeset if owner does not exist", %{params: params} do
      params = Map.put(params, :owner_id, 100_000)

      changeset = Kitchen.changeset(%Kitchen{}, params)

      assert {:error, changeset} = Repo.insert(changeset)
      refute changeset.valid?
    end

    test "invalid changeset if owner has already a kitchen", %{params: params} do
      changeset = Kitchen.changeset(%Kitchen{}, params)
      Repo.insert!(changeset)

      params =
        :kitchen
        |> params_for()
        |> Map.take([:name, :description])
        |> Map.put(:owner_id, params.owner_id)

      changeset = Kitchen.changeset(%Kitchen{}, params)
      assert {:error, changeset} = Repo.insert(changeset)
      refute changeset.valid?
    end
  end
end
