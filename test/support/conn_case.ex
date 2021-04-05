defmodule FiestaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use FiestaWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import Fiesta.Factory
  import Phoenix.ConnTest
  alias Ecto.Adapters.SQL.Sandbox
  alias Pow.Plug, as: PowPlug

  using do
    quote do
      # Import conveniences for testing with connections
      import Fiesta.Factory
      import FiestaWeb.ConnCase
      import Phoenix.ConnTest
      alias FiestaWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint FiestaWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Fiesta.Repo)

    unless tags[:async] do
      Sandbox.mode(Fiesta.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def login(conn), do: do_login(conn, insert(:user))

  def login(conn, user), do: do_login(conn, user)

  defp do_login(conn, user) do
    conn
    |> bypass_through(FiestaWeb.Router, [:browser, :not_authenticated])
    |> dispatch(FiestaWeb.Endpoint, :get, "/")
    |> PowPlug.create(user)
  end
end
