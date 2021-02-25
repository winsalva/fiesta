defmodule FiestaWeb.PageController do
  use FiestaWeb, :controller

  alias Fiesta.Users.User

  def index(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "index.html", changeset: changeset)
  end
end
