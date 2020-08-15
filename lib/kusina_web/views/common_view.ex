defmodule KusinaWeb.CommonView do
  use KusinaWeb, :view

  @doc """
  Gets the flash from conn in tuple format where first element
  is the flash key and second element is the flash message.
  """
  def get_flash_in_tuple(conn) do
    conn
    |> get_flash()
    |> Map.to_list()
    |> case do
      [] -> {nil, nil}
      flash -> List.first(flash)
    end
  end
end
