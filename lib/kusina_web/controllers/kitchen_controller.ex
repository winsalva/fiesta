defmodule KusinaWeb.KitchenController do
  use KusinaWeb, :controller

  action_fallback(KusinaWeb.FallbackController)
end
