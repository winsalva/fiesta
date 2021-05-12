defmodule Fiesta.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Fiesta.Repo
  use Fiesta.KitchenFactory
  use Fiesta.UserFactory
  use Fiesta.ProductFactory
end
