defmodule Fiesta.UserFactory do
  @moduledoc false
  import Fiesta.TestHelpers

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        password = random_letters(10)
        hashed_password = Bcrypt.hash_pwd_salt(password)

        %Fiesta.Accounts.User{
          email: Faker.Internet.email(),
          password: password,
          hashed_password: hashed_password,
          kitchen: build(:kitchen)
        }
      end
    end
  end
end
