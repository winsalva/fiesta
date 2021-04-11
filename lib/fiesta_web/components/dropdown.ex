defmodule FiestaWeb.Component.Dropdown do
  @moduledoc false
  use FiestaWeb, :component

  @doc "Dropdown clickable"
  slot clickable

  @doc "Dropdown content"
  slot default

  def render(assigns) do
    ~H"""
    <div x-data="{ isOpen: false }">
      <div class="cursor-pointer" x-on:click="isOpen = true">
        <slot name="clickable" />
      </div>

      <div x-cloak x-show="isOpen" x-on:click.away="isOpen = false"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="transform opacity-0 scale-95"
        x-transition:enter-end="transform opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="transform opacity-100 scale-100"
        x-transition:leave-end="transform opacity-0 scale-95"
        class="origin-top-left absolute z-999 mt-2 w-auto rounded bg-white shadow-md border border-solid border-gray-secondary">
        <slot />
      </div>
    </div>
    """
  end
end
