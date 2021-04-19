defmodule FiestaWeb.Helpers.HTML do
  @moduledoc """
  Generates customized html tags
  """

  use Phoenix.HTML

  alias FiestaWeb.Router.Helpers, as: Routes

  def icon_tag(conn, name, opts \\ []) do
    classes = Keyword.get(opts, :class, "") <> " icon"

    content_tag(:svg, class: classes) do
      tag(:use, "xlink:href": Routes.static_path(conn, "/images/icons.svg#" <> name))
    end
  end

  def price_input(form, field, opts) do
    opts =
      opts
      |> Keyword.put_new(:value, price_value(input_value(form, field)))
      |> Keyword.update(:class, "", &(&1 <> " price-input"))

    text_input(form, field, opts)
  end

  defp price_value(nil), do: nil
  defp price_value(%{"amount" => amount}), do: amount
  defp price_value(%Money{} = money), do: Money.to_decimal(money)
end
