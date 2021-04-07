defmodule Fiesta.UserFactory do
  @moduledoc false
  import Fiesta.TestHelpers
  alias Pow.Ecto.Schema.Password

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        password = random_letters(10)
        password_hash = Password.pbkdf2_hash(password)

        %Fiesta.Users.User{
          email: Faker.Internet.email(),
          password: password,
          password_hash: password_hash,
          kitchen: build(:kitchen)
        }
      end
    end
  end
end
