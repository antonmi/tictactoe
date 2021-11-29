defmodule Tictactoe.Pipelines.GameMoveTest do
  use ExUnit.Case

  alias Tictactoe.{Game, Move}
  alias Tictactoe.Pipelines.GameMove
  alias ALF.Manager

  setup do
    Manager.start(GameMove)
  end

  test "pipeline" do
    event = %GameMove{game: %Game{}, move: %Move{}}
    [event]
    |> Manager.stream_to(GameMove)
    |> Enum.to_list
    |> IO.inspect
  end
end
