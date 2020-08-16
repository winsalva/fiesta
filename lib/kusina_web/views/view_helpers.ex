defmodule KusinaWeb.ViewHelpers do
  @moduledoc false

  alias Kusina.Repo
  alias Kusina.Users.User

  def get_kitchen_from_user(%User{} = user) do
    user
    |> Repo.preload(:kitchen)
    |> Map.get(:kitchen)
  end

  def get_kitchen_from_user(nil), do: nil
end
