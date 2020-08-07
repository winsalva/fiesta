defmodule Kusina.Repo.Migrations.AddStatusAndDescriptionToLobbies do
  use Ecto.Migration

  def change do
    alter table(:lobbies) do
      add(:status, :string)
      add(:description, :text)
    end
  end
end
