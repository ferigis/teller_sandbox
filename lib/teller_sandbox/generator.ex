defmodule Teller.Sandbox.Generator do
  @moduledoc """
  Defines utilities for generating data
  """

  ## Behaviour API

  @doc """
  Generates the entity id based on a seed
  """
  @callback generate_id(String.t()) :: String.t()

  @doc """
  Generates the entity based on a seed
  """
  @callback generate(String.t(), Keyword.t()) :: map()

  @optional_callbacks generate_id: 1

  ## Generator Helpers

  @doc """
  Generate a random integer based on a seed and ceil
  """
  @spec generate_integer(String.t(), integer) :: integer
  def generate_integer(seed, ceil) do
    # probably there is a better way to do this
    int = :erlang.phash2(seed)
    Integer.mod(int, ceil)
  end

  defmacro __using__(_opts) do
    quote do
      # Implements the Generator behaviour
      @behaviour Teller.Sandbox.Generator

      alias Teller.Sandbox.Generator

      @doc """
      Picks one element from the list based on a seed.
      """
      @spec pick_one(list, String.t()) :: term
      def pick_one(list, seed) do
        index = Generator.generate_integer(seed, length(list))
        Enum.at(list, index)
      end

      @doc """
      Generates a random String based on a seed.
      """
      @spec generate_string(String.t()) :: String.t()
      def generate_string(seed) do
        # probably there is a better way to do this
        Base.encode16(seed)
      end

      @doc """
      Generates a random digits based on a seed.
      """
      @spec generate_digits(String.t(), integer) :: String.t()
      def generate_digits(seed, size) do
        int = :erlang.phash2(seed)
        String.slice("#{int}", -size..-1)
      end

      @doc """
      Generate a random float based on a seed
      """
      @spec generate_float(String.t()) :: float
      def generate_float(seed) do
        int_part = Generator.generate_integer(seed, 200)
        int = :erlang.phash2(seed)
        decimals = String.slice("#{int}", 0..1)

        {float, ""} = Float.parse("#{int_part}.#{decimals}")
        float
      end
    end
  end
end
