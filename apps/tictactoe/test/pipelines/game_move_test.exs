defmodule Tictactoe.Pipelines.GameMoveTest do
  use ExUnit.Case

  alias Tictactoe.{Game, Move}
  alias Tictactoe.Pipelines.GameMove
  alias ALF.Manager

  def build_game(field) do
    %Game{
      field: field,
      user_x_uuid: "user_x",
      user_o_uuid: "user_o",
      turn_uuid: "user_x"
    }
  end

  setup do
    Manager.start(GameMove)
  end

  setup do
    game = build_game([[1, nil, nil], [nil, nil, nil], [nil, nil, nil]])
    move = %Move{user_uuid: "user_x", position: 4}
    %{game: game, move: move}
  end

  describe "success case" do
    test "pipeline", %{game: game, move: move} do
      event = %GameMove{game: game, move: move}

      [%GameMove{game: game, move: move}] =
        [event]
        |> Manager.stream_to(GameMove)
        |> Enum.to_list()

      assert is_nil(move.error)
      assert move.result == :continue

      assert game.field == [[1, nil, nil], [nil, 1, nil], [nil, nil, nil]]
      assert game.turn_uuid == "user_o"
    end

    test "victory case" do
      game = build_game([[1, nil, nil], [nil, 1, nil], [nil, nil, nil]])
      move = %Move{user_uuid: "user_x", position: 8}

      [%GameMove{game: game, move: move}] =
        [%GameMove{game: game, move: move}]
        |> Manager.stream_to(GameMove)
        |> Enum.to_list()

      assert is_nil(move.error)
      assert move.result == :victory

      assert game.field == [[1, nil, nil], [nil, 1, nil], [nil, nil, 1]]
      assert game.turn_uuid == "user_o"
    end
  end

  describe "error cases" do
    test "invalid move", %{game: game} do
      move = %Move{user_uuid: "user_x", position: 0}

      [%GameMove{game: new_game, move: new_move}] =
        [%GameMove{game: game, move: move}]
        |> Manager.stream_to(GameMove)
        |> Enum.to_list()

      assert new_move.error == :square_is_taken

      assert new_game.field == [[1, nil, nil], [nil, nil, nil], [nil, nil, nil]]
      assert new_game.turn_uuid == "user_x"
    end
  end
end
