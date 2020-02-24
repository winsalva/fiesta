defmodule Katoto.Repo do
  use Ecto.Repo,
    otp_app: :katoto,
    adapter: Ecto.Adapters.Postgres
end
