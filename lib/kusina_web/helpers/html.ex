defmodule KusinaWeb.Helpers.HTML do
  @moduledoc """
  Generates customized html tags
  """

  use Phoenix.HTML

  alias KusinaWeb.Router.Helpers, as: Routes

  def icon_tag(conn, name, opts \\ []) do
    classes = Keyword.get(opts, :class, "") <> " icon"

    content_tag(:svg, class: classes) do
      tag(:use, "xlink:href": Routes.static_path(conn, "/images/icons.svg#" <> name))
    end
  end
end
