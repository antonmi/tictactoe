defmodule Tictactoe.EventPoolTest do
  use Tictactoe.DataCase

  alias Tictactoe.EventPool

  alias Tictactoe.Pipelines.{
    UserEnters,
    UserMoves,
    ShowLeaderBoard,
    UserCancelsGame,
    UserChecksTheirGames
  }

  test "if pipelines started" do
    [
      UserEnters,
      UserMoves,
      ShowLeaderBoard,
      UserCancelsGame,
      UserChecksTheirGames
    ]
    |> Enum.each(fn pipeline ->
      assert is_pid(Process.whereis(pipeline))
    end)
  end

  describe "process_event/1" do
    test "user_enters event" do
      {:ok, event} =
        %UserEnters{username: "anton"}
        |> EventPool.process_event()

      assert %UserEnters{username: "anton", error: nil} = event
    end
  end
end
