defmodule Kusina.Factory do
  use ExMachina.Ecto, repo: Kusina.Repo
  use Kusina.KitchenFactory
  use Kusina.UserFactory
end
