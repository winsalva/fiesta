defmodule Kusina.Repo.Migrations.CreateKitchens do
  use Ecto.Migration

  def change do
    create table(:kitchens) do
      add(:name, :string)
      add(:description, :text)
      add(:owner_id, references(:users, on_delete: :delete_all))
      timestamps()
    end

    create unique_index(:kitchens, [:owner_id])
  end
end
