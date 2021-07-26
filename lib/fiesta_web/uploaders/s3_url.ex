defmodule FiestaWeb.Uploaders.S3URL do
  @moduledoc """
  Used to build Amazon S3 AWS Objects URL
  """
  alias Phoenix.Naming
  alias Ecto.UUID

  def key(%struct{}, filename) do
    struct
    |> to_string
    |> String.split(".")
    |> List.last()
    |> Naming.underscore()
    |> Kernel.<>("/#{UUID.generate()}/#{filename}")
  end

  def build(bucket, region, key) do
    "https://#{bucket}.s3.#{region}.amazonaws.com/#{key}"
  end
end
