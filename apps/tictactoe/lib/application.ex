defmodule Tictactoe.Application do
  use Application

  alias Tictactoe.Repo

  alias Tictactoe.Pipelines.{
    UserEnters,
    GameInfo,
    UserMoves,
    ShowLeaderBoard,
    UserCancelsGame,
    UserChecksTheirGames
  }

  @impl true
  def start(_type, _args) do
    children = [Repo]

    opts = [strategy: :one_for_one, name: Assistant.Supervisor]
    start_pipelines()
    Supervisor.start_link(children, opts)
  end

  def start_pipelines() do
    pipelines_to_start()
    |> Enum.each(fn pipeline ->
      :ok = ALF.Manager.start(pipeline)
    end)
  end

  defp pipelines_to_start() do
    [
      UserEnters,
      GameInfo,
      UserMoves,
      ShowLeaderBoard,
      UserCancelsGame,
      UserChecksTheirGames
    ]
  end
end
