defmodule Kusina.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Kusina.Repo
  use Kusina.KitchenFactory
  use Kusina.UserFactory
end
