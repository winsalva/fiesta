defmodule FiestaWeb.Uploaders.GCSUpload do
  @moduledoc """
  Build form fields for GCS direct upload
  """
  alias FiestaWeb.Uploaders.MenuItem, as: MenuItemUploader
  alias Plug.Conn.Query

  def sign_form_upload(filename, scope) do
    presigned_url = MenuItemUploader.url({filename, scope}, :original, signed: true)

    %URI{query: query} = URI.parse(presigned_url)

    %{"Expires" => expiry_date, "GoogleAccessId" => google_access_id} = Query.decode(query)

    date_today = Date.utc_today() |> Date.to_iso8601() |> String.replace("-", "")

    x_goog_date =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
      |> String.replace("-", "")
      |> String.replace(":", "")

    expiry_date =
      expiry_date
      |> String.to_integer()
      |> DateTime.from_unix!()
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()

    fields = %{
      "key" => filename,
      "x-goog-credential" => "#{google_access_id}/#{date_today}/auto/storage/goog4_request",
      "x-goog-algorithm" => "GOOG4-HMAC-SHA256",
      "x-goog-date" => x_goog_date,
      "bucket" => "menu-please-prod-uploads"
      # "Expires" => expiry_date
    }

    policy = %{
      "expiration" => expiry_date,
      "conditions" => [
        ["starts-with", "$key", ""],
        %{"bucket" => "menu-please-prod-uploads"},
        ["content-length-range", 0, 1_000_000],
        %{"x-goog-algorithm" => fields["x-goog-algorithm"]},
        %{"x-goog-credential" => fields["x-goog-credential"]},
        %{"x-goog-date" => fields["x-goog-date"]}
        # %{"Expires" => fields["Expires"]}
      ]
    }

    IO.inspect(policy, label: "POLICY")

    base64_encoded_policy =
      policy
      |> Jason.encode!()
      |> Base.encode64()

    signature = sign_policy(base64_encoded_policy, date_today)

    {:ok,
     Map.merge(fields, %{"policy" => base64_encoded_policy, "x-goog-signature" => signature})}
  end

  defp sign_policy(base64_encoded_policy, date_today) do
    date_today
    |> derive_signing_key()
    |> hmac_sha256(base64_encoded_policy)
    |> Base.encode16()
  end

  defp derive_signing_key(date_today) do
    key_date = hmac_sha256("GOOG4" <> "/NFCbgxgO5WmrYpQ0Ucc91gQhVueX2J56yM7Q3RB", date_today)
    key_region = hmac_sha256(key_date, "auto")
    key_service = hmac_sha256(key_region, "storage")
    signing_key = hmac_sha256(key_service, "goog4_request")

    signing_key
  end

  defp hmac_sha256(key, content) do
    :crypto.hmac(:sha256, key, content)
  end
end
