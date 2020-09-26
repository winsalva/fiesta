defmodule KusinaWeb.Helpers.Live do
  @moduledoc false

  def mount_socket(socket), do: {:ok, socket}
  def noreply_socket(socket), do: {:noreply, socket}
end
