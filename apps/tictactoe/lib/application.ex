defmodule Tictactoe.Application do
  use Application

  alias Tictactoe.{EventPool, Repo}

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
    children = [
      :poolboy.child_spec(:event_sink, poolboy_config()),
      Repo
    ]

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

  defp poolboy_config do
    [
      name: {:local, :event_sink},
      worker_module: EventPool,
      size: 5,
      max_overflow: 2
    ]
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
