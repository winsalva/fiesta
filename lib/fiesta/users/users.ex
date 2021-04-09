defmodule Fiesta.Users do
  @moduledoc """
  Users context
  """
  use Pow.Ecto.Context,
    repo: Fiesta.Repo,
    user: Fiesta.Users.User
end
