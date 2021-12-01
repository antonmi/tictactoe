defmodule Tictactoe.Pipelines.UserMovesTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Users}
  alias Tictactoe.Pipelines.UserMoves
  alias ALF.Manager

  setup do
    Manager.start(UserMoves)
  end

  def process_event(event) do
    [result] =
      [event]
      |> Manager.stream_to(UserMoves)
      |> Enum.to_list()

    result
  end

  describe "simple success case - move in existing active game" do
    setup do
      {:ok, user_x} = Users.create("john")
      {:ok, user_o} = Users.create("jack")
      {:ok, game} = Games.create(user_x.uuid, user_o.uuid)

      event = %UserMoves{token: user_x.uuid, game_uuid: game.uuid, move: 4}

      %{event: event, game: game, user_x: user_x, user_o: user_o}
    end

    test "it creates a new user and a game", %{event: event, user_o: user_o} do
      result = process_event(event)

      game_data = result.game_data
      user_o_uuid = user_o.uuid

      assert %{
               field: [nil, nil, nil, nil, 1, nil, nil, nil, nil],
               status: "continue",
               turn_uuid: ^user_o_uuid
             } = game_data[:game]
    end
  end
end
