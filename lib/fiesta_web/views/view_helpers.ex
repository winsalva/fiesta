defmodule FiestaWeb.ViewHelpers do
  @moduledoc false

  alias Fiesta.Repo
  alias Fiesta.Users.User

  def get_kitchen_from_user(%User{} = user) do
    user
    |> Repo.preload(:kitchen)
    |> Map.get(:kitchen)
  end

  def get_kitchen_from_user(nil), do: nil
end
