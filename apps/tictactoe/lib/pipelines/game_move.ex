defmodule Tictactoe.Pipelines.GameMove do
  use ALF.DSL

  alias Tictactoe.{Game, Move}

  defstruct game: %Game{},
            move: %Move{},
            result: nil,
            error: nil

  @type t :: %__MODULE__{
          game: Game.t(),
          move: Move.t(),
          result: :continue | :victory | :draw,
          error: atom
        }

  @components [
    stage(:validate_move),
    stage(:apply_move),
    stage(:check_game_status)
  ]

  def validate_move(%__MODULE__{game: game, move: move} = event, _opts) do
    case Game.validate_move(game, move) do
      :ok ->
        event

      {:error, error} ->
        %{event | error: error}
    end
  end

  def apply_move(%__MODULE__{error: nil} = event, _opts) do
    game = Game.apply_move(event.game, event.move)
    %{event | game: game}
  end

  def apply_move(%__MODULE__{error: _error} = event, _opts), do: event

  def check_game_status(%__MODULE__{error: nil, game: game} = event, _opts) do
    status = Game.check_game_status(event.game)

    %{event | result: status, game: %{game | status: status}}
  end

  def check_game_status(%__MODULE__{} = event, _opts), do: event
end
