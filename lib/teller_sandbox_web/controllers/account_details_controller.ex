defmodule Teller.SandboxWeb.AccountDetailsController do
  @moduledoc false
  use Teller.SandboxWeb, :controller

  alias Teller.Sandbox.Repo

  action_fallback Teller.SandboxWeb.FallbackController

  ## API

  @doc false
  @spec show_me(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show_me(conn, %{"account_id" => acct_id}) do
    user_id = conn.assigns[:user_id]

    with {:ok, details} <- Repo.fetch_account_details_by_user(acct_id, user_id) do
      render(conn, "show.json", account_details: details)
    end
  end
end
