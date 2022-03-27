defmodule Teller.SandboxWeb.AccountTransactionControllerTest do
  use Teller.SandboxWeb.ConnCase

  describe "GET /accounts/:account_id/transactions" do
    test "error: auth required", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ==")
        )

      assert response(conn, 401) == "Unauthorized"
    end

    test "error: wrong token", %{conn: conn} do
      conn =
        conn
        |> with_token("wrong")
        |> get(Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert response(conn, 401) == "Unauthorized"
    end

    test "ok: returns all accounts' transactions", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ=="))

      assert [
               %{
                 "id" => "txn_bXlfc2VlZF80X2FjY3RfMQ==",
                 "account_id" => "acc_bXlfc2VlZF80X2FjY3RfMQ==",
                 "type" => "card_payment",
                 "amount" => "-98.12",
                 "date" => "2022-03-27",
                 "description" => "74786E5F62586C666332566C5A4638305832466A593352664D513D3D",
                 "details" => %{
                   "category" => "tax",
                   "counterparty" => %{"name" => "Sonic", "type" => "organization"}
                 },
                 "processing_status" => "complete",
                 "running_balance" => "525.73",
                 "status" => "posted",
                 "links" => %{
                   "account" => "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D",
                   "self" =>
                     "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/transactions/txn_bXlfc2VlZF80X2FjY3RfMQ%3D%3D"
                 }
               }
               | _
             ] = json_response(conn, 200)
    end

    test "ok: pagination only count", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(
          Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ==") <>
            "?count=2"
        )

      assert [_, _] = json_response(conn, 200)
    end

    test "error: pagination wrong count", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(
          Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ==") <>
            "?count=one"
        )

      assert %{"errors" => %{"count" => ["is invalid"]}} == json_response(conn, 422)
    end

    test "ok: pagination only from_id", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(
          Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ==") <>
            "?from_id=txn_bXlfc2VlZF80X2FjY3RfMQ=="
        )

      assert txns = json_response(conn, 200)
      assert length(txns) == 89
    end

    test "ok: wrong from_id", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(
          Routes.account_transaction_path(conn, :index_me, "acc_bXlfc2VlZF80X2FjY3RfMQ==") <>
            "?from_id=wrong"
        )

      assert [] == json_response(conn, 200)
    end
  end

  describe "GET /account/:id/transactions/:txn_id" do
    test "error: auth required", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.account_transaction_path(
            conn,
            :show_me,
            "acc_bXlfc2VlZF80X2FjY3RfMQ==",
            "txn_bXlfc2VlZF80X2FjY3RfMQ=="
          )
        )

      assert response(conn, 401) == "Unauthorized"
    end

    test "error: wrong token", %{conn: conn} do
      conn =
        conn
        |> with_token("wrong")
        |> get(
          Routes.account_transaction_path(
            conn,
            :show_me,
            "acc_bXlfc2VlZF80X2FjY3RfMQ==",
            "txn_bXlfc2VlZF80X2FjY3RfMQ=="
          )
        )

      assert response(conn, 401) == "Unauthorized"
    end

    test "ok: returns the account", %{conn: conn} do
      conn =
        conn
        |> with_token("test_tok_user1")
        |> get(
          Routes.account_transaction_path(
            conn,
            :show_me,
            "acc_bXlfc2VlZF80X2FjY3RfMQ==",
            "txn_bXlfc2VlZF80X2FjY3RfMQ=="
          )
        )

      assert %{
               "id" => "txn_bXlfc2VlZF80X2FjY3RfMQ==",
               "account_id" => "acc_bXlfc2VlZF80X2FjY3RfMQ==",
               "type" => "card_payment",
               "amount" => "-98.12",
               "date" => "2022-03-27",
               "description" => "74786E5F62586C666332566C5A4638305832466A593352664D513D3D",
               "details" => %{
                 "category" => "tax",
                 "counterparty" => %{"name" => "Sonic", "type" => "organization"}
               },
               "processing_status" => "complete",
               "running_balance" => "525.73",
               "status" => "posted",
               "links" => %{
                 "account" => "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D",
                 "self" =>
                   "http://localhost:4002/accounts/acc_bXlfc2VlZF80X2FjY3RfMQ%3D%3D/transactions/txn_bXlfc2VlZF80X2FjY3RfMQ%3D%3D"
               }
             } == json_response(conn, 200)
    end

    test "error: not found", %{conn: conn} do
      assert conn
             |> with_token("test_tok_user1")
             |> get(
               Routes.account_transaction_path(
                 conn,
                 :show_me,
                 "acc_bXlfc2VlZF80X2FjY3RfMQ==",
                 "wrong"
               )
             )
             |> json_response(404)
    end
  end
end
