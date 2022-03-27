defmodule Teller.SandboxWeb.Plugs.Auth do
  @moduledoc """
  Implements a plug function `basic_auth`.

  It is inspired from `Plug.BasicAuth` implementation.
  """

  import Plug.Conn

  alias Plug.BasicAuth

  @valid_tokens [
    "test_tok_user1",
    "test_tok_user2",
    "test_tok_user3",
    "test_tok_user4",
    "test_tok_user5",
    "test_tok_user6"
  ]

  @doc false
  @spec basic_auth(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def basic_auth(conn, opts) do
    with {token, _} <- BasicAuth.parse_basic_auth(conn),
         true <- Enum.member?(@valid_tokens, token) do
      assign(conn, :user_id, token)
    else
      _ -> conn |> BasicAuth.request_basic_auth(opts) |> halt()
    end
  end
end
