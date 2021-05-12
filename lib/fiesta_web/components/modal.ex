defmodule FiestaWeb.Component.Modal do
  @moduledoc false
  use FiestaWeb, :live_component

  @doc "Open or closes the modal"
  data open?, :boolean, default: false

  @doc "Modal header"
  slot header

  @doc "Modal body"
  slot default

  @doc "Modal footer"
  slot footer

  def render(%{open?: true} = assigns) do
    ~H"""
    <div id={{ @id }} class="modal-container fixed bottom-0 inset-x-0 px-4 pb-4 inset-0 flex overflow-auto bg-black bg-opacity-50 z-10">
      <div class="bg-white m-auto rounded shadow-md z-50 overflow-y-auto" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
        <header class="modal-header py-4 px-6 border-b border-gray-200 flex justify-between">
          <slot name="header" />

          <button type="button" class="flex-grow-0" :on-click="close_modal" id={{ @id <> "-close-modal" }} phx-update="ignore" :hook="FeatherIcons">
            <i data-feather="x"></i>
          </button>
        </header>

        <div class="modal-body p-6">
          <slot />
        </div>

        <footer class="modal-footer border-t border-gray-200 p-6">
          <slot name="footer" />
        </footer>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div id={{ @id }}></div>
    """
  end

  def handle_event("open_modal", _, socket) do
    {:noreply, assign(socket, :open?, true)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, :open?, false)}
  end

  def close(id) do
    send_update(__MODULE__, id: id, open?: false)
  end
end
