defmodule Kusina.Users.User do
  @moduledoc false
  use Ecto.Schema
  use Pow.Ecto.Schema

  import Pow.Ecto.Schema.Changeset, only: [user_id_field_changeset: 3, new_password_changeset: 3]

  @pow_config Application.compile_env!(:kusina, :pow, [])

  schema "users" do
    pow_user_fields()

    has_one(:kitchen, Kusina.Kitchens.Kitchen, foreign_key: :owner_id)

    timestamps()
  end

  def login_changeset(user_or_changeset, params \\ %{}) do
    user_or_changeset
    |> user_id_field_changeset(params, @pow_config)
    |> new_password_changeset(params, @pow_config)
  end
end
