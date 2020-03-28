defmodule Katoto.Chat.Lobby do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

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
