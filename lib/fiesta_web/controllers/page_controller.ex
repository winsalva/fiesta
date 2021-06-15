defmodule FiestaWeb.PageController do
  use FiestaWeb, :controller

  alias Fiesta.Accounts.User

  def index(conn, _params) do
    changeset = User.registration_changeset(%User{}, %{})
    render(conn, "index.html", changeset: changeset)
  end
end
