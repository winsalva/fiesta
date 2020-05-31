defmodule Katoto.Chat.Lobby do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "lobbies" do
    field :name, :string
    field :description, :string
    field :status, LobbyStatus

    timestamps()
  end

  @required [:name]
  @fields @required ++ [:status, :description]

  @doc false
  def changeset(lobby, attrs \\ %{}) do
    lobby
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end
