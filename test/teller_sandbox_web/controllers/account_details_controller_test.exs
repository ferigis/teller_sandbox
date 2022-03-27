defmodule Teller.SandboxWeb.AccountDetailsControllerTest do
  use Teller.SandboxWeb.ConnCase

  describe "GET /account/:id/details" do
    test "error: auth required", %{conn: conn} do
      conn =
        get(conn, Routes.account_details_path(conn, :show_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert response(conn, 401) == "Unauthorized"
    end

    test "error: wrong token", %{conn: conn} do
      conn =
        conn
        |> with_token("wrong")
        |> get(Routes.account_details_path(conn, :show_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert response(conn, 401) == "Unauthorized"
    end

    test "ok: returns the account details", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(Routes.account_details_path(conn, :show_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert %{
               "account_id" => "acc_bXlfc2VlZF80X2FjY3RfMQ==",
               "account_number" => "634208861315",
               "routing_numbers" => %{"arch" => "071341817"},
               "links" => %{
                 "self" =>
                   "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/details",
                 "account" => "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D"
               }
             } == json_response(conn, 200)
    end

    test "error: not found", %{conn: conn} do
      assert conn
             |> with_token("test_tok_user1")
             |> get(Routes.account_details_path(conn, :show_me, "wrong"))
             |> json_response(404)
    end
  end
end
