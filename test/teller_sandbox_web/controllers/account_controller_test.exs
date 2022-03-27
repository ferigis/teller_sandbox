defmodule Teller.SandboxWeb.AccountControllerTest do
  use Teller.SandboxWeb.ConnCase

  describe "GET /accounts" do
    test "error: auth required", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index_me))
      assert response(conn, 401) == "Unauthorized"
    end

    test "error: wrong token", %{conn: conn} do
      conn = conn |> with_token("wrong") |> get(Routes.account_path(conn, :index_me))
      assert response(conn, 401) == "Unauthorized"
    end

    test "ok: returns all accounts", %{conn: conn} do
      conn = conn |> with_token("test_tok_user1") |> get(Routes.account_path(conn, :index_me))

      assert [
               %{
                 "currency" => "USD",
                 "enrollment_id" =>
                   "enr_656E725F69645F6163635F62586C666332566C5A4638305832466A593352664D513D3D",
                 "id" => "acc_bXlfc2VlZF80X2FjY3RfMQ==",
                 "institution" => %{"id" => "capital_one", "name" => "Capital One"},
                 "last_four" => "0414",
                 "links" => %{
                   "self" => "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D",
                   "balances" =>
                     "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/balances",
                   "details" =>
                     "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/details",
                   "transactions" =>
                     "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/transactions"
                 },
                 "name" => "Barack Obama",
                 "subtype" => "checking",
                 "type" => "depository"
               }
             ] == json_response(conn, 200)
    end
  end

  describe "GET /account/:id" do
    test "error: auth required", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :show_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))
      assert response(conn, 401) == "Unauthorized"
    end

    test "error: wrong token", %{conn: conn} do
      conn =
        conn
        |> with_token("wrong")
        |> get(Routes.account_path(conn, :show_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert response(conn, 401) == "Unauthorized"
    end

    test "ok: returns the account", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(Routes.account_path(conn, :show_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert %{
               "currency" => "USD",
               "enrollment_id" =>
                 "enr_656E725F69645F6163635F62586C666332566C5A4638305832466A593352664D513D3D",
               "id" => "acc_bXlfc2VlZF80X2FjY3RfMQ==",
               "institution" => %{"id" => "capital_one", "name" => "Capital One"},
               "last_four" => "0414",
               "links" => %{
                 "self" => "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D",
                 "balances" =>
                   "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/balances",
                 "details" =>
                   "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/details",
                 "transactions" =>
                   "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/transactions"
               },
               "name" => "Barack Obama",
               "subtype" => "checking",
               "type" => "depository"
             } == json_response(conn, 200)
    end

    test "error: not found", %{conn: conn} do
      assert conn
             |> with_token("test_tok_user1")
             |> get(Routes.account_path(conn, :show_me, "wrong"))
             |> json_response(404)
    end
  end
end
