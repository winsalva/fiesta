defmodule Kusina.TestHelpers do
  @moduledoc false

  alias Faker.Util

  def random_letters(length \\ 3, opts \\ []) do
    function =
      case Keyword.get(opts, :format, :upper) do
        :upper -> &Util.upper_letter/0
        :lower -> &Util.lower_letter/0
        :mixed -> &Util.letter/0
      end

    Util.join(length, "", function)
  end
end
