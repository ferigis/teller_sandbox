defmodule Teller.SandboxWeb.AccountTransactionView do
  use Teller.SandboxWeb, :view

  def render("index.json", %{account_transactions: transactions}) do
    render_many(transactions, __MODULE__, "account_transaction.json")
  end

  def render("show.json", %{account_transaction: account_transaction}) do
    render_one(account_transaction, __MODULE__, "account_transaction.json")
  end

  def render("account_transaction.json", %{account_transaction: account_transaction}) do
    %{
      id: account_transaction.id,
      account_id: account_transaction.account_id,
      amount: "-#{account_transaction.amount}",
      date: calculate_date(account_transaction.days_from_today),
      description: account_transaction.description,
      details: account_transaction.details,
      processing_status: account_transaction.processing_status,
      running_balance: "#{account_transaction.running_balance}",
      status: account_transaction.status,
      type: account_transaction.type,
      links: %{
        account:
          %Conn{}
          |> Routes.account_path(:show_me, account_transaction.account_id)
          |> resolve_url(),
        self:
          %Conn{}
          |> Routes.account_transaction_path(
            :show_me,
            account_transaction.account_id,
            account_transaction.id
          )
          |> resolve_url()
      }
    }
  end

  ## Private functions

  defp calculate_date(days_from_today) do
    today = Date.utc_today()
    Date.add(today, days_from_today)
  end
end
