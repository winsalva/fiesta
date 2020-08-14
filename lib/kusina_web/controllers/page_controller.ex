defmodule KusinaWeb.PageController do
  use KusinaWeb, :controller

  plug(:put_layout, "landing_page.html" when action in [:index])

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
