defmodule Kusina.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  import Pow.Ecto.Schema.Changeset, only: [user_id_field_changeset: 3, new_password_changeset: 3]

  @pow_config Application.get_env(:kusina, :pow, [])

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  def login_changeset(user_or_changeset, params \\ %{}) do
    user_or_changeset
    |> user_id_field_changeset(params, @pow_config)
    |> new_password_changeset(params, @pow_config)
  end
end
