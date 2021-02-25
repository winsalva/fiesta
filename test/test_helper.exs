ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Fiesta.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
Faker.start()
