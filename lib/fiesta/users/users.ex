defmodule Fiesta.Users do
  use Pow.Ecto.Context,
    repo: Fiesta.Repo,
    user: Fiesta.Users.User

  @moduledoc """
  Users context
  """
end
