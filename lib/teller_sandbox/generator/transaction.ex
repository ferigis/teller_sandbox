defmodule Teller.Sandbox.Generator.Transaction do
  @moduledoc """
  Encapsulates the needed info for a Transaction.

  It uses and implements `Teller.Sandbox.Generator`.
  """

  use Teller.Sandbox.Generator

  @typedoc "Type for the Transaction"
  @type t :: %__MODULE__{}

  defstruct [
    :id,
    :account_id,
    :amount,
    :running_balance,
    :description,
    :details,
    # 0 means today, 1 means yesterday...
    days_from_today: 0,
    processing_status: "complete",
    subtype: "checking",
    type: "card_payment",
    status: "posted"
  ]

  @doc """
  Generates an Account id
  """
  @impl Teller.Sandbox.Generator
  def generate_id(seed) when is_binary(seed) do
    "txn_#{Base.encode64(seed)}"
  end

  @doc """
  Generates an Account
  """
  @impl Teller.Sandbox.Generator
  def generate(id, opts) when is_binary(id) do
    acct_id = Keyword.fetch!(opts, :account_id)
    running_balance = Keyword.get(opts, :running_balance, 303.4)
    days_from_today = Keyword.get(opts, :days_from_today, 0)

    %__MODULE__{
      id: id,
      account_id: acct_id,
      amount: generate_float(id),
      running_balance: running_balance,
      description: generate_string(id),
      days_from_today: days_from_today,
      details: %{
        category: pick_one(categories(), id),
        counterparty: %{
          name: pick_one(merchants(), id),
          type: "organization"
        }
      }
    }
  end

  ## Private functions

  defp categories do
    [
      "accommodation",
      "advertising",
      "bar",
      "charity",
      "clothing",
      "dining",
      "education",
      "entertainment",
      "fuel",
      "groceries",
      "health",
      "home",
      "income",
      "insurance",
      "office",
      "phone",
      "service",
      "shopping",
      "software",
      "sport",
      "tax",
      "transport",
      "utilities"
    ]
  end

  defp merchants do
    [
      "Uber",
      "Uber Eats",
      "Lyft",
      "Five Guys",
      "In-N-Out Burger",
      "Chick-Fil-A",
      "AMC Metreon",
      "Apple",
      "Amazon",
      "Walmart",
      "Target",
      "Hotel Tonight",
      "Misson Ceviche",
      "The Creamery",
      "Caltrain",
      "Wingstop",
      "Slim Chickens",
      "CVS",
      "Duane Reade",
      "Walgreens",
      "Rooster & Rice",
      "McDonald's",
      "Burger King",
      "KFC",
      "Popeye's",
      "Shake Shack",
      "Lowe's",
      "The Home Depot",
      "Costco",
      "Kroger",
      "iTunes",
      "Spotify",
      "Best Buy",
      "TJ Maxx",
      "Aldi",
      "Dollar General",
      "Macy's",
      "H.E. Butt",
      "Dollar Tree",
      "Verizon Wireless",
      "Sprint PCS",
      "T-Mobile",
      "Kohl's",
      "Starbucks",
      "7-Eleven",
      "AT&T Wireless",
      "Rite Aid",
      "Nordstrom",
      "Ross",
      "Gap",
      "Bed, Bath & Beyond",
      "J.C. Penney",
      "Subway",
      "O'Reilly",
      "Wendy's",
      "Dunkin' Donuts",
      "Petsmart",
      "Dick's Sporting Goods",
      "Sears",
      "Staples",
      "Domino's Pizza",
      "Pizza Hut",
      "Papa John's",
      "IKEA",
      "Office Depot",
      "Foot Locker",
      "Lids",
      "GameStop",
      "Sephora",
      "MAC",
      "Panera",
      "Williams-Sonoma",
      "Saks Fifth Avenue",
      "Chipotle Mexican Grill",
      "Exxon Mobil",
      "Neiman Marcus",
      "Jack In The Box",
      "Sonic",
      "Shell"
    ]
  end
end
