defmodule KusinaWeb.ControllerHelpers do
  @moduledoc false

  def verify_token_expiry(token_timeout) do
    case DateTime.compare(DateTime.utc_now(), token_timeout) do
      :lt -> :ok
      _ -> {:error, :token_timeout}
    end
  end
end
