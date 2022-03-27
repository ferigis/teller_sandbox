defmodule Teller.SandboxWeb.AccountDetailsView do
  use Teller.SandboxWeb, :view

  def render("show.json", %{account_details: account_details}) do
    render_one(account_details, __MODULE__, "account_details.json")
  end

  def render("account_details.json", %{account_details: account_details}) do
    %{
      account_id: account_details.account_id,
      account_number: account_details.account_number,
      routing_numbers: account_details.routing_numbers,
      links: %{
        account:
          %Conn{} |> Routes.account_path(:show_me, account_details.account_id) |> resolve_url(),
        self:
          %Conn{}
          |> Routes.account_details_path(:show_me, account_details.account_id)
          |> resolve_url()
      }
    }
  end
end
