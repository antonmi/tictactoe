defmodule Tictactoe.GamesTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Users}

  describe "create" do
    setup do
      {:ok, user_x} = Users.create("user_x")
      {:ok, user_o} = Users.create("user_o")
      %{user_x: user_x, user_o: user_o}
    end

    test "success case", %{user_x: user_x, user_o: user_o} do
      {:ok, game} = Games.create(user_x.uuid, user_o.uuid)
      assert game.field == [nil, nil, nil, nil, nil, nil, nil, nil, nil]
      assert game.turn_uuid == user_x.uuid
    end

    test "success case without user_o", %{user_x: user_x} do
      {:ok, game} = Games.create(user_x.uuid, nil)
      assert game.turn_uuid == user_x.uuid
      assert is_nil(game.user_o_uuid)
    end
  end
end
