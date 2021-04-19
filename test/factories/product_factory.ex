defmodule Fiesta.ProductFactory do
  @moduledoc false
  import Fiesta.TestHelpers

  defmacro __using__(_opts) do
    quote do
      def menu_category_factory do
        %Fiesta.Products.MenuCategory{
          name: random_letters(10)
        }
      end

      def menu_item_factory do
        %Fiesta.Products.MenuItem{
          name: random_letters(10),
          description: random_letters(50),
          price: %Money{amount: 100, currency: :PHP},
          category: build(:menu_category)
        }
      end
    end
  end
end
