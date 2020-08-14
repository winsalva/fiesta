defmodule Kusina.Users.UserTest do
  use Kusina.DataCase, async: true

  alias Kusina.Users.User

  describe "login_changeset/2" do
    setup do
      {:ok, params: params_for(:user)}
    end

    test "valid changeset", %{params: params} do
      changeset = User.login_changeset(%User{}, params)

      assert changeset.valid?
    end

    test "returns invalid changeset if email is missing", %{params: params} do
      params = Map.delete(params, :email)
      changeset = User.login_changeset(%User{}, params)

      refute changeset.valid?
    end

    test "returns invalid changeset if password is missing", %{params: params} do
      params = Map.delete(params, :password)
      changeset = User.login_changeset(%User{}, params)

      refute changeset.valid?
    end

    test "returns invalid changeset if both email and password is missing", %{params: params} do
      params = Map.drop(params, [:email, :password])
      changeset = User.login_changeset(%User{}, params)

      refute changeset.valid?
    end
  end
end
