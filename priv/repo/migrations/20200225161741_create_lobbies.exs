defmodule Katoto.Repo.Migrations.CreateLobbies do
  use Ecto.Migration

  def change do
    create table(:lobbies) do
      add :name, :string

      timestamps()
    end

  end
end
