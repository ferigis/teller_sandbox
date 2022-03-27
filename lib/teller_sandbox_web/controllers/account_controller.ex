defmodule Teller.SandboxWeb.AccountController do
  @moduledoc false
  use Teller.SandboxWeb, :controller

  alias Teller.Sandbox.Repo

  action_fallback Teller.SandboxWeb.FallbackController

  ## API

  @doc false
  @spec index_me(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index_me(conn, _params) do
    user_id = conn.assigns[:user_id]
    accounts = Repo.get_accounts_by_user(user_id)
    render(conn, "index.json", accounts: accounts)
  end

  @doc false
  @spec show_me(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show_me(conn, %{"account_id" => acct_id}) do
    user_id = conn.assigns[:user_id]

    with {:ok, account} <- Repo.fetch_account_by_user(acct_id, user_id) do
      render(conn, "show.json", account: account)
    end
  end
end
