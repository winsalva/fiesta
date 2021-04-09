defmodule FiestaWeb.Component.Menu do
  @moduledoc false
  use FiestaWeb, :live_component

  alias FiestaWeb.Component.Modal

  @doc "Left part"
  slot left

  @doc "Middle part usually the text"
  slot default

  @doc "Right part"
  slot right

  def render(assigns) do
    ~H"""
    <div class="p-2 flex" id={{ @id }} :hook={{ "FeatherIcons", from: Modal }}>
      <div class="flex-grow-0">
        <i data-feather="chevron-right"></i>
      </div>

      <div class="flex-grow truncate">
        <slot />
      </div>

      <div class="flex-grow-0">
        <i data-feather="more-vertical"></i>
      </div>
    </div>
    """
  end
end
