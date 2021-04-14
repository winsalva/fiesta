defmodule FiestaWeb.DashboardLive.Index do
  @moduledoc false
  use Phoenix.LiveView
  alias FiestaWeb.DashboardView
  alias Fiesta.Users

  def render(assigns) do
    DashboardView.render("index.html", assigns)
  end

  def mount(_, %{"user_id" => user_id}, socket) do
    user = Users.get_by(id: user_id)

    {:ok, assign(socket, current_user: user)}
  end
end
