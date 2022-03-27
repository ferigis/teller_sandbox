defmodule Teller.Sandbox.Generator.Account do
  @moduledoc """
  Encapsulates the needed info for an Account.

  It uses and implements `Teller.Sandbox.Generator`.
  """

  use Teller.Sandbox.Generator

  @typedoc "Type for the Account"
  @type t :: %__MODULE__{}

  defstruct [
    :id,
    :enrollment_id,
    :institution,
    :last_four,
    :name,
    :details,
    :balance,
    :transactions,
    currency: "USD",
    status: "open",
    subtype: "checking",
    type: "depository"
  ]

  @doc """
  Generates an Account id
  """
  @impl Teller.Sandbox.Generator
  def generate_id(seed) when is_binary(seed) do
    "acc_#{Base.encode64(seed)}"
  end

  @doc """
  Generates an Account
  """
  @impl Teller.Sandbox.Generator
  def generate(id, _opts \\ []) when is_binary(id) do
    {inst_id, inst_name} = pick_one(institutions(), id)

    %__MODULE__{
      id: id,
      enrollment_id: "enr_" <> generate_string("enr_id_#{id}"),
      name: pick_one(names(), id),
      last_four: generate_digits(id, 4),
      institution: %{
        id: inst_id,
        name: inst_name
      }
    }
  end

  ## Private functions

  defp institutions do
    [
      {"chase", "Chase"},
      {"bank_of_america", "Bank of America"},
      {"wells_fargo", "Wells Fargo"},
      {"citibank", "Citibank"},
      {"capital_one", "Capital One"}
    ]
  end

  defp names do
    [
      "My Checking",
      "Jimmy Carter",
      "Ronald Reagan",
      "George H. W. Bush",
      "Bill Clinton",
      "George W. Bush",
      "Barack Obama",
      "Donald Trump"
    ]
  end
end
