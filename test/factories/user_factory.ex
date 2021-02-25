defmodule Fiesta.UserFactory do
  @moduledoc false
  import Fiesta.TestHelpers

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Fiesta.Users.User{
          email: Faker.Internet.email(),
          password: random_letters(10)
        }
      end
    end
  end
end
