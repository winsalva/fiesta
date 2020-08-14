defmodule KusinaWeb.DashboardController do
  use KusinaWeb, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
