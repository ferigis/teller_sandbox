defmodule Teller.Sandbox.Generator.AccountTest do
  use ExUnit.Case

  alias Teller.Sandbox.Generator.Account

  describe "generate/1" do
    test "ok: creates an account" do
      acct_id = Account.generate_id("seed1")

      assert %{
               id: ^acct_id,
               currency: "USD",
               enrollment_id: "enr_" <> _,
               institution: %{
                 id: inst_id,
                 name: inst_name
               },
               last_four: last_four,
               name: name,
               status: "open",
               subtype: "checking",
               type: "depository"
             } = Account.generate(acct_id)

      assert "acc_" <> _ = acct_id
      assert not is_nil(inst_id)
      assert not is_nil(inst_name)
      assert not is_nil(last_four)
      assert String.length(last_four) == 4
      assert {_, ""} = Integer.parse(last_four)
      assert not is_nil(name)
    end

    test "ok: same account with the same seed" do
      assert Account.generate("seed1") == Account.generate("seed1")
      assert Account.generate("seed1") != Account.generate("seed2")
    end
  end

  describe "generate_id/2" do
    test "ok: creates an id" do
      assert "acc_" <> _ = Account.generate_id("seed1")
    end

    test "ok: same id with the same seeds" do
      assert Account.generate_id("seed1") == Account.generate_id("seed1")
      assert Account.generate_id("seed1") != Account.generate_id("seed2")
    end
  end
end
