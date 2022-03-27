defmodule Teller.Sandbox.Generator.AccountBalance do
  @moduledoc """
  Encapsulates the needed info for an Account Balance.

  It uses and implements `Teller.Sandbox.Generator`.
  """

  use Teller.Sandbox.Generator

  @typedoc "Type for the Account Balance"
  @type t :: %__MODULE__{}

  defstruct [
    :account_id,
    :available,
    :ledger
  ]

  @doc """
  Generates an Account
  """
  @impl Teller.Sandbox.Generator
  def generate(id, opts) when is_binary(id) do
    acct_id = Keyword.fetch!(opts, :account_id)
    available = Keyword.get(opts, :available, generate_float(id))
    ledger = Keyword.get(opts, :ledger, available + 7.5)

    %__MODULE__{
      account_id: acct_id,
      available: available,
      ledger: ledger
    }
  end
end
