defmodule Teller.SandboxWeb.AccountBalancesController do
  @moduledoc false
  use Teller.SandboxWeb, :controller

  alias Teller.Sandbox.Repo

  action_fallback Teller.SandboxWeb.FallbackController

  ## API

  @doc false
  @spec show_me(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show_me(conn, %{"account_id" => acct_id}) do
    user_id = conn.assigns[:user_id]

    with {:ok, balances} <- Repo.fetch_account_balance_by_user(acct_id, user_id) do
      render(conn, "show.json", account_balances: balances)
    end
  end
end
