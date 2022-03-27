defmodule Teller.Sandbox.Generator.TransactionTest do
  use ExUnit.Case

  alias Teller.Sandbox.Generator.Transaction

  describe "generate/1" do
    test "ok: creates an transaction" do
      txn_id = Transaction.generate_id("seed1")
      acct_id = "acc_xxxxx"

      assert %{
               id: ^txn_id,
               account_id: ^acct_id,
               amount: amount,
               days_from_today: 0,
               description: desc,
               processing_status: "complete",
               details: %{
                 category: details_cat,
                 counterparty: %{
                   name: details_count_name,
                   type: "organization"
                 }
               },
               status: "posted",
               type: "card_payment",
               running_balance: 303.4
             } = Transaction.generate(txn_id, account_id: acct_id)

      assert "txn_" <> _ = txn_id
      assert not is_nil(amount)
      assert not is_nil(desc)
      assert not is_nil(details_cat)
      assert not is_nil(details_count_name)
    end

    test "ok: with final_balance and days from today" do
      txn_id = Transaction.generate_id("seed1")
      acct_id = "acc_xxxxx"

      assert %{
               id: ^txn_id,
               account_id: ^acct_id,
               days_from_today: 5,
               running_balance: "202.45"
             } =
               Transaction.generate(txn_id,
                 account_id: acct_id,
                 running_balance: "202.45",
                 days_from_today: 5
               )
    end

    test "ok: same transaction with the same seed" do
      assert Transaction.generate("seed1", account_id: "acct_id") ==
               Transaction.generate("seed1", account_id: "acct_id")

      assert Transaction.generate("seed1", account_id: "acct_id") !=
               Transaction.generate("seed2", account_id: "acct_id")
    end
  end

  describe "generate_id/2" do
    test "ok: creates an id" do
      assert "txn_" <> _ = Transaction.generate_id("seed1")
    end

    test "ok: same id with the same seeds" do
      assert Transaction.generate_id("seed1") == Transaction.generate_id("seed1")
      assert Transaction.generate_id("seed1") != Transaction.generate_id("seed2")
    end
  end
end
