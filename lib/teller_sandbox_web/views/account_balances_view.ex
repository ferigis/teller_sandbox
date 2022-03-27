defmodule Teller.SandboxWeb.AccountBalancesView do
  use Teller.SandboxWeb, :view

  def render("show.json", %{account_balances: account_balances}) do
    render_one(account_balances, __MODULE__, "account_balances.json")
  end

  def render("account_balances.json", %{account_balances: account_balances}) do
    %{
      account_id: account_balances.account_id,
      available: account_balances.available,
      ledger: account_balances.ledger,
      links: %{
        account:
          %Conn{} |> Routes.account_path(:show_me, account_balances.account_id) |> resolve_url(),
        self:
          %Conn{}
          |> Routes.account_balances_path(:show_me, account_balances.account_id)
          |> resolve_url()
      }
    }
  end
end
