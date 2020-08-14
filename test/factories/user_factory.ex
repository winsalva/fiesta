defmodule Kusina.UserFactory do
  import Kusina.TestHelpers

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Kusina.Users.User{
          email: Faker.Internet.email(),
          password: random_letters(10)
        }
      end
    end
  end
end
