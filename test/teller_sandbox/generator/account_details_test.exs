defmodule Teller.Sandbox.Generator.AccountDetailsTest do
  use ExUnit.Case

  alias Teller.Sandbox.Generator.Account
  alias Teller.Sandbox.Generator.AccountDetails

  describe "generate/1" do
    test "ok: creates an account details" do
      acct_id = Account.generate_id("seed1")

      assert %{
               account_id: ^acct_id,
               account_number: acct_number,
               routing_numbers: %{
                 arch: arch
               }
             } = AccountDetails.generate(acct_id, account_id: acct_id)

      assert {_, ""} = Integer.parse(acct_number)
      assert {_, ""} = Integer.parse(arch)
    end

    test "ok: same account details with the same seed" do
      assert AccountDetails.generate("seed1", account_id: "acct_id") ==
               AccountDetails.generate("seed1", account_id: "acct_id")

      assert AccountDetails.generate("seed1", account_id: "acct_id") !=
               AccountDetails.generate("seed2", account_id: "acct_id")
    end
  end
end
