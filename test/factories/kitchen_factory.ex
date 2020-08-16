defmodule Kusina.KitchenFactory do
  defmacro __using__(_opts) do
    quote do
      def kitchen_factory do
        %Kusina.Kitchens.Kitchen{
          name: Faker.Pizza.company(),
          description: Faker.Lorem.sentence(),
          owner: build(:user)
        }
      end
    end
  end
end
