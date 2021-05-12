defmodule Fiesta.Repo.Migrations.AddNameToMenus do
  use Ecto.Migration

  def change do
    alter table(:menus) do
      add(:name, :string)
    end
  end
end
