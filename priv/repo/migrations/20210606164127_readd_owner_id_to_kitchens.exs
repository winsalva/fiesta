defmodule Fiesta.Repo.Migrations.ReaddOwnerIdtoKitchens do
  use Ecto.Migration

  def change do
    alter table(:kitchens) do
      add(:owner_id, references(:users, on_delete: :delete_all))
    end

    create unique_index(:kitchens, [:owner_id])
  end
end
