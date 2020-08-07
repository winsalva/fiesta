defmodule Kusina.Repo do
  use Ecto.Repo,
    otp_app: :kusina,
    adapter: Ecto.Adapters.Postgres
end
