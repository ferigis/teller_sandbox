defmodule Teller.Sandbox.Generator.AccountDetails do
  @moduledoc """
  Encapsulates the needed info for an Account Details.

  It uses and implements `Teller.Sandbox.Generator`.
  """

  use Teller.Sandbox.Generator

  @typedoc "Type for the Account Details"
  @type t :: %__MODULE__{}

  defstruct [
    :account_id,
    :account_number,
    :routing_numbers
  ]

  @doc """
  Generates an Account
  """
  @impl Teller.Sandbox.Generator
  def generate(seed, opts) when is_binary(seed) do
    acct_id = Keyword.fetch!(opts, :account_id)

    %__MODULE__{
      account_id: acct_id,
      account_number:
        generate_digits("acct_n_#{seed}", 8) <> generate_digits("acct_n2_#{seed}", 4),
      routing_numbers: %{
        arch: generate_digits("arch#{seed}", 8) <> generate_digits("arch2_#{seed}", 1)
      }
    }
  end
end
