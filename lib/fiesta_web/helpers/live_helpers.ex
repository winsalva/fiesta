defmodule FiestaWeb.Helpers.Live do
  @moduledoc false
  import Phoenix.LiveView

  def mount_socket(socket), do: {:ok, socket}
  def noreply_socket(socket), do: {:noreply, socket}

  @doc """
  Cancel all unconsumed upload entries
  """
  def cancel_all_uploads(socket, upload_name) do
    upload_conf = fetch_upload_config!(socket, upload_name)
    entries = Map.get(upload_conf, :entries, [])
    entry_refs = Enum.map(entries, & &1.ref)

    Enum.reduce(entry_refs, socket, fn ref, socket ->
      cancel_upload(socket, upload_name, ref)
    end)
  end

  @doc """
  Fetches upload configuration. Raises error if uploads or upload name is not found
  """
  def fetch_upload_config!(socket, upload_name) do
    socket.assigns
    |> Map.fetch!(:uploads)
    |> Map.fetch!(upload_name)
  end
end
