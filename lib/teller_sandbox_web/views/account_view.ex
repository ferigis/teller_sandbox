defmodule Teller.SandboxWeb.AccountView do
  use Teller.SandboxWeb, :view

  def render("index.json", %{accounts: accounts}) do
    render_many(accounts, __MODULE__, "account.json")
  end

  def render("show.json", %{account: account}) do
    render_one(account, __MODULE__, "account.json")
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      currency: account.currency,
      enrollment_id: account.enrollment_id,
      institution: account.institution,
      last_four: account.last_four,
      name: account.name,
      type: account.type,
      subtype: account.subtype,
      links: %{
        self: %Conn{} |> Routes.account_path(:show_me, account.id) |> resolve_url(),
        details: %Conn{} |> Routes.account_details_path(:show_me, account.id) |> resolve_url(),
        balances: %Conn{} |> Routes.account_balances_path(:show_me, account.id) |> resolve_url(),
        transactions:
          %Conn{} |> Routes.account_transaction_path(:index_me, account.id) |> resolve_url()
      }
    }
  end
end
