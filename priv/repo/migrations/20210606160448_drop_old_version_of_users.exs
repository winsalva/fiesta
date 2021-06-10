defmodule Fiesta.Repo.Migrations.DropOldVersionOfUsers do
  use Ecto.Migration

  def up do
    drop constraint("kitchens", "kitchens_owner_id_fkey")
    alter table("kitchens") do
      remove :owner_id, :bigint
    end
    execute("delete from kitchens")
    execute("delete from menu_items")
    execute("delete from menu_categories")
    execute("delete from menus")
    drop table("users")
  end

  def down do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    alter table("kitchens") do
      add :owner_id, references(:users, on_delete: :delete_all)
    end
  end
end
