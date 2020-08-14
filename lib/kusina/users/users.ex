defmodule Kusina.Users do
  use Pow.Ecto.Context,
    repo: Kusina.Repo,
    user: Kusina.Users.User

  @moduledoc """
  Users context
  """
end
