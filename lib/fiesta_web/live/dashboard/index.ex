defmodule FiestaWeb.DashboardLive.Index do
  @moduledoc false
  use Phoenix.LiveView
  alias Fiesta.Accounts
  alias FiestaWeb.DashboardView

  def render(assigns) do
    DashboardView.render("index.html", assigns)
  end

  def mount(_, %{"user_id" => user_id}, socket) do
    user = Accounts.get_user(user_id)

    {:ok, assign(socket, current_user: user)}
  end
end
