defmodule FiestaWeb.Uploaders.SimpleGCSUpload do
  @moduledoc """
  Dependency-free S3 Form Upload using HTTP POST sigv4
  https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-post-example.html
  """

  @doc """
  Signs a form upload.
  The configuration is a map which must contain the following keys:
    * `:region` - The AWS region, such as "us-east-1"
    * `:access_key_id` - The AWS access key id
    * `:secret_access_key` - The AWS secret access key
  Returns a map of form fields to be used on the client via the JavaScript `FormData` API.

  ## Options
    * `:key` - The required key of the object to be uploaded.
    * `:max_file_size` - The required maximum allowed file size in bytes.
    * `:content_type` - The required MIME type of the file to be uploaded.
    * `:expires_in` - The required expiration time in milliseconds from now
      before the signed upload expires.
  ## Examples
      config = %{
        region: "us-east-1",
        access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
        secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
      }
      {:ok, fields} =
        SimpleS3Upload.sign_form_upload(config, "my-bucket",
          key: "public/my-file-name",
          content_type: "image/png",
          max_file_size: 10_000,
          expires_in: :timer.hours(1)
        )
  """
  def sign_form_upload(config, bucket, opts) do
    key = Keyword.fetch!(opts, :key)
    max_file_size = Keyword.fetch!(opts, :max_file_size)
    content_type = Keyword.fetch!(opts, :content_type)
    expires_in = Keyword.fetch!(opts, :expires_in)

    expires_at = DateTime.add(DateTime.utc_now(), expires_in, :millisecond)
    goog_date = goog_date(DateTime.utc_now())
    credential = credential(config, expires_at)

    policy = """
    {
      "expiration": "#{DateTime.to_iso8601(expires_at)}",
      "conditions": [
        ["eq", "$key", "#{key}"],
        {"bucket": "#{bucket}"},
        {"x-goog-credential": "#{credential}"},
        {"x-goog-algorithm": "GOOG4-HMAC-SHA256"},
        {"x-goog-date": "#{goog_date}"}
      ]
    }
    """

    encoded_policy = Base.encode64(policy)

    fields = %{
      "key" => key,
      "bucket" => bucket,
      "x-goog-credential" => credential,
      "x-goog-algorithm" => "GOOG4-HMAC-SHA256",
      "x-goog-date" => goog_date,
      "policy" => encoded_policy,
      "x-goog-signature" => signature(config, expires_at, encoded_policy)
    }

    {:ok, fields}
  end

  defp goog_date(time) do
    time
    |> NaiveDateTime.to_iso8601()
    |> String.split(".")
    |> List.first()
    |> String.replace("-", "")
    |> String.replace(":", "")
    |> Kernel.<>("Z")
  end

  defp credential(%{} = config, %DateTime{} = expires_at) do
    "#{config.access_key_id}/#{short_date(expires_at)}/#{config.region}/storage/goog4_request"
  end

  defp signature(config, %DateTime{} = expires_at, encoded_policy) do
    config
    |> signing_key(expires_at, "storage")
    |> sha256(encoded_policy)
    |> Base.encode16(case: :lower)
  end

  defp signing_key(%{} = config, %DateTime{} = expires_at, service) when service in ["storage"] do
    goog_date = short_date(expires_at)
    %{secret_access_key: secret, region: region} = config

    ("GOOG4" <> secret)
    |> sha256(goog_date)
    |> sha256(region)
    |> sha256(service)
    |> sha256("goog4_request")
  end

  defp short_date(%DateTime{} = expires_at) do
    expires_at
    |> goog_date()
    |> String.slice(0..7)
  end

  defp sha256(secret, msg), do: :crypto.hmac(:sha256, secret, msg)
end
