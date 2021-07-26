[
  import_deps: [:ecto, :phoenix, :surface],
  inputs: ["*.{ex,exs,sface}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs,sface}"],
  subdirectories: ["priv/*/migrations"]
]
