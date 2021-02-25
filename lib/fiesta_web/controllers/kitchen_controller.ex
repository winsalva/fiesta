defmodule FiestaWeb.KitchenController do
  use FiestaWeb, :controller

  action_fallback(FiestaWeb.FallbackController)
end
