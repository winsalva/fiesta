defmodule Kusina.Chat.LobbyTest do
  @moduledoc false
  use Kusina.DataCase

  alias Kusina.Chat.Lobby

  describe "changeset" do
    test "returns valid if params are valid" do
      changeset =
        Lobby.changeset(%Lobby{}, %{
          name: "valid name",
          status: "active",
          description: "This is a test lobby."
        })

      assert changeset.valid?
    end

    test "returns invalid changeset if status is invalid" do
      changeset = Lobby.changeset(%Lobby{}, %{name: "valid name", status: "invalid status"})

      refute changeset.valid?

      assert {:status, {"is invalid", [type: LobbyStatus, validation: :cast]}} in changeset.errors
    end
  end
end
