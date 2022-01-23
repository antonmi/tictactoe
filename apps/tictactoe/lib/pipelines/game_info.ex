defmodule Tictactoe.Pipelines.GameInfo do
  use ALF.DSL

  alias Tictactoe.{Game, Games}

  defstruct uuid: nil,
            game: nil,
            game_data: nil,
            error: nil

  @type t :: %__MODULE__{
               uuid: String.t(),
               game: Game.t(),
               game_data: map(),
               error: nil | :no_such_game | :invalid_input
        }

  @components [
    stage(:validate_input),
    stage(:find_game),
    stage(:prepare_game_data)
  ]

  def validate_input(%__MODULE__{} = event, _) do
    if event.uuid do
      event
    else
      done!(%{event | error: :invalid_input})
    end
  end

  def find_game(%__MODULE__{uuid: uuid} = event, _) do
    case Games.find(uuid) do
      %Game{} = game ->
        %{event | game: game}

      nil ->
        done!(%{event | error: :no_such_game})
    end
  end

  def prepare_game_data(%__MODULE__{game: game} = event, _) do
    game_data = Games.game_data(game)
    %{event | game_data: game_data}
  end
end
