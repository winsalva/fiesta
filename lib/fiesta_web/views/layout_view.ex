defmodule FiestaWeb.LayoutView do
  use FiestaWeb, :view

  def menu_item(title, data_feather, path) do
    ~E"""
    <li class="w-auto md:w-full mx-auto md:px-3 mb-4">
      <a href="<%= path %>" class="flex flex-col md:flex-row items-center md:justify-start">
        <i data-feather="<%= data_feather %>" class="text-2xl md:text-base md:mr-2"></i>
        <span class="text-xs md:text-base"><%= title %></span>
      </a>
    </li>
    """
  end
end
