defmodule Tictactoe.UsersTest do
  use Tictactoe.DataCase

  alias Tictactoe.Users

  describe "create/1" do
    test "success case" do
      {:ok, user} = Users.create("anton")
      assert user.name == "anton"
    end
  end
end
