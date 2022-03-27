defmodule Teller.SandboxWeb.AccountTransactionController do
  @moduledoc false
  use Params
  use Teller.SandboxWeb, :controller

  alias Teller.Sandbox.Repo

  action_fallback Teller.SandboxWeb.FallbackController

  ## Filters

  defparams(
    paginate_filter(%{
      count: :integer,
      from_id: :string
    })
  )

  ## API

  @doc false
  @spec index_me(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index_me(conn, %{"account_id" => acct_id} = params) do
    cs = paginate_filter(params)

    if cs.valid? do
      user_id = conn.assigns[:user_id]
      transactions = Repo.get_account_transactions_by_user(acct_id, user_id, Params.to_map(cs))
      render(conn, "index.json", account_transactions: transactions)
    else
      {:error, cs}
    end
  end

  @doc false
  @spec show_me(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show_me(conn, %{"account_id" => acct_id, "transaction_id" => txn_id}) do
    user_id = conn.assigns[:user_id]

    with {:ok, txn} <- Repo.fetch_account_transaction_by_user(acct_id, txn_id, user_id) do
      render(conn, "show.json", account_transaction: txn)
    end
  end
end
