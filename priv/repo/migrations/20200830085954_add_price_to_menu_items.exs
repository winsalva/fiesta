defmodule Fiesta.Repo.Migrations.AddPriceToMenuItems do
  use Ecto.Migration

  def change do
    alter table(:menu_items) do
      add(:price, :money_with_currency)
    end
  end
end
