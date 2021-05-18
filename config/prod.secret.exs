# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :fiesta, Fiesta.Repo,
  username: "postgres",
  password: "postgres",
  database: "fiesta_prod",
  socket_dir: "/cloudsql/menu-please:us-central1:fiesta-prod",
  pool_size: 15

config :fiesta, FiestaWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: "KDGl7gOREcPf8+IGxJ/v1d/Fo0urs07s+lac9/Bany/oWQX0KDtT2eO4SE6WlKGi"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :fiesta, FiestaWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
