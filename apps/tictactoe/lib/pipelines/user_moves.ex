defmodule Tictactoe.Pipelines.UserMoves do
  use ALF.DSL

  alias Tictactoe.{Games, Game, Users, User}
  alias Tictactoe.Pipelines.{GameMove, GameMoveAdapter}

  defstruct token: nil,
            game_uuid: nil,
            move: nil,
            user: nil,
            game: nil,
            move_result: nil,
            game_data: %{},
            error: nil

  @type t :: %__MODULE__{
          token: String.t(),
          game_uuid: String.t(),
          move: integer,
          user: User.t(),
          game: Game.t(),
          move_result: atom,
          game_data: map,
          error: nil | :invalid_input | :no_such_user | :no_such_game | :cant_update_game
        }

  @components [
    stage(:validate_input),
    stage(:find_user_by_token),
    stage(:find_game),
    stage(:check_if_game_active),
    plug_with(GameMoveAdapter, [name: :adapter], do: stages_from(GameMove)),
    stage(:check_error_after_move),
    stage(:update_game_record),
    stage(:update_user_scores_if_game_finished),
    stage(:prepare_game_data)
  ]

  def validate_input(%__MODULE__{} = event, _) do
    if event.token && event.game_uuid && event.move do
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

  def check_if_game_active(%__MODULE__{game: game} = event, _) do
    case game.status do
      "active" ->
        event

      "cancelled" ->
        done!(%{event | error: :game_is_cancelled})

      _other ->
        done!(%{event | error: :game_is_not_active})
    end
  end

  def check_error_after_move(%__MODULE__{error: nil} = event, _), do: event

  def check_error_after_move(%__MODULE__{error: _error} = event, _) do
    done!(event)
  end

  def update_game_record(%__MODULE__{game: game} = event, _) do
    case Games.insert(game) do
      {:ok, game} ->
        %{event | game: game}

      {:error, _any} ->
        done!(%{event | error: :cant_update_game})
    end
  end

  def update_user_scores_if_game_finished(%__MODULE__{game: game, user: user} = event, _opts) do
    {:ok, user} =
      case game.status do
        "victory" ->
          Users.increase_scores(user, 3)

        "draw" ->
          Users.increase_scores(user, 1)

        "active" ->
          {:ok, user}
      end

    %{event | user: user}
  end

  def prepare_game_data(%__MODULE__{game: game} = event, _opts) do
    game_data = Games.game_data(game)
    %{event | game_data: game_data}
  end
end
