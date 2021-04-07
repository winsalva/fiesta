defmodule FiestaWeb.Users.RegistrationControllerTest do
  @moduledoc false
  use FiestaWeb.ConnCase

  describe "create/2" do
    setup do
      params = params_for(:user)

      params =
        params
        |> Map.put(:kitchen, %{name: "test kitchen", description: "abc"})
        |> Map.put(:password_confirmation, params.password)

      {:ok, params: params}
    end

    test "redirects to dashboard page if successful", %{conn: conn, params: params} do
      conn = post(conn, Routes.signup_path(conn, :create), %{user: params})

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end

    test "renders errors if not successful", %{conn: conn} do
      conn = post(conn, Routes.signup_path(conn, :create), %{user: %{}})

      assert html_response(conn, 422) =~ "can&#39;t be blank"
    end
  end
end
