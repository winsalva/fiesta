defmodule KusinaWeb.PageController do
  use KusinaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
