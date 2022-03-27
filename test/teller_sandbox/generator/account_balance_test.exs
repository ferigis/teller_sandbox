defmodule Teller.Sandbox.Generator.AccountBalanceTest do
  use ExUnit.Case

  alias Teller.Sandbox.Generator.Account
  alias Teller.Sandbox.Generator.AccountBalance

  describe "generate/1" do
    test "ok: creates an account balance" do
      acct_id = Account.generate_id("seed1")

      assert %{
               account_id: ^acct_id,
               available: 303.45,
               ledger: 307.55
             } =
               AccountBalance.generate(acct_id,
                 account_id: acct_id,
                 available: 303.45,
                 ledger: 307.55
               )
    end

    test "ok: same account balance with the same seed" do
      assert AccountBalance.generate("seed1", account_id: "acct_id") ==
               AccountBalance.generate("seed1", account_id: "acct_id")

      assert AccountBalance.generate("seed1", account_id: "acct_id") !=
               AccountBalance.generate("seed2", account_id: "acct_id")
    end
  end
end
