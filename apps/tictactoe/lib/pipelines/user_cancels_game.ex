defmodule Tictactoe.Pipelines.UserCancelsGame do
  use ALF.DSL

  alias Tictactoe.{Games, Game, Users, User}

  defstruct token: nil,
            game_uuid: nil,
            user: nil,
            game: nil,
            game_data: %{},
            error: nil

  @type t :: %__MODULE__{
          token: String.t(),
          game_uuid: String.t(),
          user: User.t(),
          game: Game.t(),
          game_data: map,
          error: nil | :game_is_not_active
        }

  @components [
    stage(:validate_input),
    stage(:find_user_by_token),
    stage(:find_game),
    stage(:cancel_game),
    stage(:prepare_game_data)
  ]

  def validate_input(%__MODULE__{} = event, _) do
    if event.token && event.game_uuid do
      event
    else
      done!(%{event | error: :invalid_input})
    end
  end

  def find_user_by_token(%__MODULE__{token: token} = event, _) do
    case Users.find(token) do
      %User{} = user ->
        %{event | user: user}

      nil ->
        done!(%{event | error: :no_such_user})
    end
  end

  def find_game(%__MODULE__{game_uuid: game_uuid} = event, _) do
    case Games.find(game_uuid) do
      %Game{} = game ->
        %{event | game: game}

      nil ->
        done!(%{event | error: :no_such_game})
    end
  end

  def cancel_game(%__MODULE__{game: game} = event, _) do
    case game.status do
      "active" ->
        {:ok, game} = Games.cancel_game(game)
        %{event | game: game}
      _other ->
        %{event | error: :game_is_not_active}
    end

  end

  def prepare_game_data(%__MODULE__{game: game} = event, _opts) do
    game_data = Games.game_data(game)
    %{event | game_data: game_data}
  end
end
