defmodule Teller.SandboxWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Teller.SandboxWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Phoenix.ConnTest
  alias Plug.BasicAuth

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Teller.SandboxWeb.ConnCase

      alias Teller.SandboxWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint Teller.SandboxWeb.Endpoint

      @doc false
      @spec with_token(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
      def with_token(conn, token) do
        put_req_header(conn, "authorization", BasicAuth.encode_basic_auth(token, ""))
      end
    end
  end

  setup _tags do
    {:ok, conn: ConnTest.build_conn()}
  end
end
