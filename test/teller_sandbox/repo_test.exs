defmodule Teller.Sandbox.RepoTest do
  use ExUnit.Case

  alias Teller.Sandbox.Generator.{Account, AccountBalance, AccountDetails, Transaction}
  alias Teller.Sandbox.Repo

  describe "get_accounts_by_user/1" do
    test "ok: retrieves all accounts" do
      assert accounts1 = Repo.get_accounts_by_user("user1")
      assert accounts2 = Repo.get_accounts_by_user("user2")
      assert accounts1 != accounts2
    end

    test "ok: always retrieves the same for the same user" do
      assert Repo.get_accounts_by_user("user1") == Repo.get_accounts_by_user("user1")
      assert Repo.get_accounts_by_user("user2") == Repo.get_accounts_by_user("user2")
    end
  end

  describe "fetch_account_by_user/2" do
    test "ok: retrieves account" do
      assert {:ok, %Account{}} =
               Repo.fetch_account_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1")

      assert {:ok, %Account{}} =
               Repo.fetch_account_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user2")
    end

    test "error: not found" do
      assert {:error, :not_found} =
               Repo.fetch_account_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user1")

      assert {:error, :not_found} =
               Repo.fetch_account_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user2")
    end
  end

  describe "fetch_account_details_by_user/2" do
    test "ok: retrieves account details" do
      assert {:ok, %AccountDetails{}} =
               Repo.fetch_account_details_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1")

      assert {:ok, %AccountDetails{}} =
               Repo.fetch_account_details_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user2")
    end

    test "error: not found" do
      assert {:error, :not_found} =
               Repo.fetch_account_details_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user1")

      assert {:error, :not_found} =
               Repo.fetch_account_details_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user2")
    end
  end

  describe "fetch_account_balance_by_user/2" do
    test "ok: retrieves account details" do
      assert {:ok, %AccountBalance{}} =
               Repo.fetch_account_balance_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1")

      assert {:ok, %AccountBalance{}} =
               Repo.fetch_account_balance_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user2")
    end

    test "error: not found" do
      assert {:error, :not_found} =
               Repo.fetch_account_balance_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user1")

      assert {:error, :not_found} =
               Repo.fetch_account_balance_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user2")
    end
  end

  describe "get_account_transactions_by_user/2" do
    test "ok: retrieves all transactions" do
      assert [txn1 | _] =
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1")

      assert [txn2 | _] =
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user2")

      assert txn1 != txn2
    end

    test "ok: always retrieves the same for the same user" do
      assert Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1") ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1")

      assert Repo.get_account_transactions_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user2") ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user2")
    end

    test "error: not found" do
      assert {:error, :not_found} =
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF82X2FjY3RfMQ==", "user1")

      assert {:error, :not_found} =
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user2")
    end
  end

  describe "get_account_transactions_by_user/2 with pagination" do
    test "ok: retrieves all transactions" do
      assert [txn1, txn2, txn3, txn4 | rest] =
               all_txns =
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1")

      assert length(all_txns) == 90

      assert [txn1, txn2, txn3, txn4] ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1", %{
                 count: 4
               })

      assert rest ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1", %{
                 from_id: txn4.id
               })

      assert [txn1, txn2] ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1", %{
                 count: 2
               })

      assert [txn3, txn4] ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1", %{
                 count: 2,
                 from_id: txn2.id
               })

      assert [] ==
               Repo.get_account_transactions_by_user("acc_bXlfc2VlZF81X2FjY3RfMQ==", "user1", %{
                 from_id: "wrong"
               })
    end
  end

  describe "fetch_account_transaction_by_user/2" do
    test "ok: retrieves all transactions" do
      assert {:ok, %Transaction{}} =
               Repo.fetch_account_transaction_by_user(
                 "acc_bXlfc2VlZF81X2FjY3RfMQ==",
                 "txn_bXlfc2VlZF81X2FjY3RfMQ==",
                 "user1"
               )

      assert {:ok, %Transaction{}} =
               Repo.fetch_account_transaction_by_user(
                 "acc_bXlfc2VlZF82X2FjY3RfMQ==",
                 "txn_bXlfc2VlZF82X2FjY3RfMQ==",
                 "user2"
               )
    end

    test "ok: always retrieves the same for the same user" do
      assert Repo.fetch_account_transaction_by_user(
               "acc_bXlfc2VlZF81X2FjY3RfMQ==",
               "txn_bXlfc2VlZF81X2FjY3RfMQ==",
               "user1"
             ) ==
               Repo.fetch_account_transaction_by_user(
                 "acc_bXlfc2VlZF81X2FjY3RfMQ==",
                 "txn_bXlfc2VlZF81X2FjY3RfMQ==",
                 "user1"
               )

      assert Repo.fetch_account_transaction_by_user(
               "acc_bXlfc2VlZF82X2FjY3RfMQ==",
               "txn_bXlfc2VlZF82X2FjY3RfMQ==",
               "user2"
             ) ==
               Repo.fetch_account_transaction_by_user(
                 "acc_bXlfc2VlZF82X2FjY3RfMQ==",
                 "txn_bXlfc2VlZF82X2FjY3RfMQ==",
                 "user2"
               )
    end

    test "error: not found" do
      assert {:error, :not_found} =
               Repo.fetch_account_transaction_by_user(
                 "acc_bXlfc2VlZF82X2FjY3RfMQ==",
                 "txn_bXlfc2VlZF82X2FjY3RfMQ==",
                 "user1"
               )

      assert {:error, :not_found} =
               Repo.fetch_account_transaction_by_user(
                 "acc_bXlfc2VlZF81X2FjY3RfMQ==",
                 "txn_bXlfc2VlZF81X2FjY3RfMQ==",
                 "user2"
               )
    end
  end
end
