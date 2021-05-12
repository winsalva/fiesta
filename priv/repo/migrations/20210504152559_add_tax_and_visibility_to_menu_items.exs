defmodule Fiesta.Repo.Migrations.AddTaxAndVisibilityToMenuItems do
  use Ecto.Migration

  def change do
    alter table(:menu_items) do
      add(:tax, :decimal)
      add(:visibility, :string, default: "active")
    end
  end
end
