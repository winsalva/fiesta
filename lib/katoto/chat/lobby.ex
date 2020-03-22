defmodule Katoto.Chat.Lobby do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lobbies" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(lobby, attrs \\ %{}) do
    lobby
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
