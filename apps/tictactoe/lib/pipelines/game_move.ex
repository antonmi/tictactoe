defmodule Tictactoe.Pipelines.GameMove do
  use ALF.DSL

  alias Tictactoe.{Game, Move}

  defstruct [
    game: %Game{},
    move: %Move{}
  ]

  @components [
    stage(:validate_move),
    stage(:update_game),
    stage(:check_game_status)
  ]


  def validate_move(%__MODULE__{} = event, _opts) do
    event
  end

  def update_game(%__MODULE__{move: %Move{error: nil}} = event, _opts) do
    event
  end

  def update_game(%__MODULE__{move: %Move{error: error}} = event, _opts) when is_nil(error) do
    event
  end

  def check_game_status(%__MODULE__{} = event, _opts) do
    event
  end
end
