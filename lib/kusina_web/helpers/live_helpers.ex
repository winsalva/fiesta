defmodule KusinaWeb.Helpers.Live do
  @moduledoc false
  import Phoenix.LiveView

  def mount_socket(socket), do: {:ok, socket}
  def noreply_socket(socket), do: {:noreply, socket}

  def unauthorize(socket) do
    socket
    |> put_flash(:error, "You are unauthorized!")
    |> redirect(to: Routes.dashboard_path(socket, :index))
    |> mount_socket()
  end
end
