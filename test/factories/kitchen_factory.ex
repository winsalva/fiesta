defmodule Fiesta.KitchenFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def kitchen_factory do
        %Fiesta.Kitchens.Kitchen{
          name: Faker.Pizza.company(),
          description: Faker.Lorem.sentence()
        }
      end
    end
  end
end
