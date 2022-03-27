defmodule Teller.SandboxWeb.Router do
  use Teller.SandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    import Teller.SandboxWeb.Plugs.Auth
    plug :basic_auth
  end

  scope "/", Teller.SandboxWeb do
    pipe_through [:api, :auth]

    # Accounts
    get("/accounts", AccountController, :index_me)
    get("/accounts/:account_id", AccountController, :show_me)

    # Account details
    get("/accounts/:account_id/details", AccountDetailsController, :show_me)

    # Account balance
    get("/accounts/:account_id/balances", AccountBalancesController, :show_me)

    # Account transactions
    get("/accounts/:account_id/transactions", AccountTransactionController, :index_me)

    get(
      "/accounts/:account_id/transactions/:transaction_id",
      AccountTransactionController,
      :show_me
    )
  end
end
