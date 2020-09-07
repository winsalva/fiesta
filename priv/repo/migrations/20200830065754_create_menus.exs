defmodule Kusina.Repo.Migrations.CreateMenus do
  use Ecto.Migration

  def change do
    create table(:menus) do
      add(:kitchen_id, references(:kitchens, on_delete: :delete_all))
      timestamps()
    end

    create table(:menu_categories) do
      add(:name, :string)
      add(:menu_id, references(:menus, on_delete: :delete_all))
      timestamps()
    end

    create table(:menu_items) do
      add(:name, :string)
      add(:description, :text)
      add(:menu_category_id, references(:menu_categories, on_delete: :delete_all))
      timestamps()
    end
  end
end
