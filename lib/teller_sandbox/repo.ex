defmodule Teller.Sandbox.Repo do
  @moduledoc """
  This module encapsulates all the data needed for the system. It handles
  all the functions for accessing it.

  This module builds in compilation-time some profiles. A profile is a set
  of accounts + transactions generated with a seed.

  According to the token used by the user we will pick always the same
  profile, so the results must be always equal.
  """

  alias Teller.Sandbox.Generator
  alias Teller.Sandbox.Generator.{Account, AccountBalance, AccountDetails, Transaction}

  @profiles_num 10

  @profiles (for num <- 1..@profiles_num do
               seed = "my_seed_#{num}"
               # select how many accounts we are going to create (1..3)
               account_nums = Generator.generate_integer(seed, 3) + 1

               for acct_num <- 1..account_nums do
                 acct_seed = "#{seed}_acct_#{acct_num}"
                 acct = acct_seed |> Account.generate_id() |> Account.generate()
                 # Generate the details
                 acct_details = AccountDetails.generate(acct_seed, account_id: acct.id)
                 # Generate the balance
                 balance = AccountBalance.generate_float(acct_seed) + 500

                 acct_balance =
                   AccountBalance.generate(acct_seed, account_id: acct.id, available: balance)

                 # Generate transactions
                 today_txn =
                   acct_seed
                   |> Transaction.generate_id()
                   |> Transaction.generate(account_id: acct.id, running_balance: balance)

                 acct_transactions =
                   Enum.reduce(2..90, %{all: [today_txn], last_txn: today_txn}, fn txn_num,
                                                                                   %{
                                                                                     all:
                                                                                       txns_acc,
                                                                                     last_txn:
                                                                                       last_txn
                                                                                   } ->
                     txn_seed = "#{acct_seed}_txn_#{txn_num}"
                     balance = last_txn.running_balance + last_txn.amount

                     txn =
                       txn_seed
                       |> Transaction.generate_id()
                       |> Transaction.generate(
                         account_id: acct.id,
                         running_balance: balance,
                         days_from_today: last_txn.days_from_today + 1
                       )

                     %{all: [txn | txns_acc], last_txn: txn}
                   end)

                 %{
                   acct
                   | details: acct_details,
                     balance: acct_balance,
                     transactions: Enum.reverse(acct_transactions.all)
                 }
               end
             end)

  ## API

  @doc """
  Retrieves all accounts for a given user
  """
  @spec get_accounts_by_user(String.t()) :: [Account.t()]
  def get_accounts_by_user(user_id) do
    Account.pick_one(@profiles, user_id)
  end

  @doc """
  Retrieves an account for a given user
  """
  @spec fetch_account_by_user(String.t(), String.t()) :: {:ok, Account.t()} | {:error, :not_found}
  def fetch_account_by_user(acct_id, user_id) do
    @profiles
    |> Account.pick_one(user_id)
    |> Enum.filter(&(&1.id == acct_id))
    |> case do
      [acct] -> {:ok, acct}
      [] -> {:error, :not_found}
    end
  end

  @doc """
  Retrieves an account details for a given user
  """
  @spec fetch_account_details_by_user(String.t(), String.t()) ::
          {:ok, AccountDetails.t()} | {:error, :not_found}
  def fetch_account_details_by_user(acct_id, user_id) do
    @profiles
    |> Account.pick_one(user_id)
    |> Enum.filter(&(&1.id == acct_id))
    |> case do
      [acct] -> {:ok, acct.details}
      [] -> {:error, :not_found}
    end
  end

  @doc """
  Retrieves an account balance for a given user
  """
  @spec fetch_account_balance_by_user(String.t(), String.t()) ::
          {:ok, AccountBalance.t()} | {:error, :not_found}
  def fetch_account_balance_by_user(acct_id, user_id) do
    @profiles
    |> Account.pick_one(user_id)
    |> Enum.filter(&(&1.id == acct_id))
    |> case do
      [acct] -> {:ok, acct.balance}
      [] -> {:error, :not_found}
    end
  end

  @doc """
  Retrieves all account transactions for a given user
  """
  @spec get_account_transactions_by_user(String.t(), String.t(), map) ::
          [Transaction.t(), ...] | {:error, :not_found}
  def get_account_transactions_by_user(acct_id, user_id, params \\ %{}) do
    @profiles
    |> Account.pick_one(user_id)
    |> Enum.filter(&(&1.id == acct_id))
    |> case do
      [acct] -> maybe_paginate(acct.transactions, params)
      [] -> {:error, :not_found}
    end
  end

  @doc """
  Retrieves an account transaction for a given user
  """
  @spec fetch_account_transaction_by_user(String.t(), String.t(), String.t()) ::
          {:ok, Transaction.t()} | {:error, :not_found}
  def fetch_account_transaction_by_user(acct_id, txn_id, user_id) do
    with {:ok, acct} <- fetch_account_by_user(acct_id, user_id) do
      do_fetch_account_transaction_by_user(acct.transactions, txn_id)
    end
  end

  ## Private functions

  defp do_fetch_account_transaction_by_user(transactions, txn_id) do
    transactions
    |> Enum.filter(&(&1.id == txn_id))
    |> case do
      [txn] -> {:ok, txn}
      [] -> {:error, :not_found}
    end
  end

  defp maybe_paginate(transactions, params) do
    transactions
    |> maybe_from_id(params[:from_id])
    |> maybe_count(params[:count])
  end

  defp maybe_from_id(transactions, nil), do: transactions
  defp maybe_from_id([], _), do: []
  defp maybe_from_id([%{id: id} | rest], id), do: rest
  defp maybe_from_id([_ | rest], id), do: maybe_from_id(rest, id)

  defp maybe_count(transactions, nil), do: transactions

  defp maybe_count(transactions, count) do
    Enum.take(transactions, count)
  end
end
