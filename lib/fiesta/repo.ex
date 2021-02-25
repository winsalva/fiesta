defmodule Fiesta.Repo do
  use Ecto.Repo,
    otp_app: :fiesta,
    adapter: Ecto.Adapters.Postgres
end
