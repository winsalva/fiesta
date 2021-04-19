defmodule Fiesta.CustomType.MultiCurrencyPrice do
  @moduledoc """
  A modification for Money.Ecto.Composite.Type to accept string prices
  usually received from form inputs
  """
  use Ecto.Type

  @spec type() :: :money_with_currency
  def type, do: :money_with_currency

  @spec load({integer(), atom() | String.t()}) :: {:ok, Money.t()}
  def load({amount, currency}) do
    {:ok, Money.new(amount, currency)}
  end

  @spec dump(any()) :: :error | {:ok, {integer(), String.t()}}
  def dump(%Money{} = money), do: {:ok, {money.amount, to_string(money.currency)}}
  def dump(_), do: :error

  @spec cast(Money.t() | {integer(), String.t()} | map() | any()) :: :error | {:ok, Money.t()}
  def cast(%Money{} = money) do
    {:ok, money}
  end

  def cast({amount, currency})
      when is_integer(amount) and (is_binary(currency) or is_atom(currency)) do
    {:ok, Money.new(amount, currency)}
  end

  def cast(%{"amount" => amount, "currency" => currency})
      when is_integer(amount) and (is_binary(currency) or is_atom(currency)) do
    {:ok, Money.new(amount, currency)}
  end

  def cast(%{"amount" => amount, "currency" => currency})
      when is_binary(amount) and is_binary(currency) do
    Money.parse(amount, String.to_existing_atom(currency))
  end

  def cast(%{amount: amount, currency: currency})
      when is_integer(amount) and (is_binary(currency) or is_atom(currency)) do
    {:ok, Money.new(amount, currency)}
  end

  def cast(_), do: :error
end
