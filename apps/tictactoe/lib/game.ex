defmodule Tictactoe.Game do
  defstruct uuid: "",
            field: [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]],
            user_x_uuid: "",
            user_o_uuid: "",
            turn_uuid: ""

  @type t :: %__MODULE__{
          uuid: String.t(),
          field: list(list()),
          user_x_uuid: String.t(),
          user_o_uuid: String.t(),
          turn_uuid: String.t()
        }

  alias Tictactoe.{Game, Move}

  @spec validate_move(Game.t(), Move.t()) ::
          :ok
          | {:error, :not_your_turn}
          | {:error, :position_outside_range}
          | {:error, :square_is_taken}
  def validate_move(%Game{} = game, %Move{} = move) do
    with :ok <- validate_turn(game, move),
         :ok <- validate_position(move),
         :ok <- validate_square(game, move) do
      :ok
    end
  end

  @spec apply_move(Game.t(), Move.t()) :: Game.t()
  def apply_move(game, move) do
    number = number_to_put_on_the_field(game)

    new_field =
      game.field
      |> List.flatten()
      |> List.update_at(move.position, fn nil -> number end)
      |> Enum.chunk_every(3)

    %{toggle_turn(game) | field: new_field}
  end

  @spec check_game_status(Game.t()) :: :continue | :victory | :draw
  def check_game_status(game) do
    with :nope <- check_victory(game),
         :nope <- check_draw(game) do
      :continue
    end
  end

  defp validate_turn(%Game{turn_uuid: turn_uuid}, %Move{user_uuid: user_uuid}) do
    if turn_uuid == user_uuid, do: :ok, else: {:error, :not_your_turn}
  end

  defp validate_position(%Move{position: position}) do
    if position in 0..9, do: :ok, else: {:error, :position_outside_range}
  end

  defp validate_square(%Game{field: field}, %Move{position: position}) do
    in_position =
      field
      |> List.flatten()
      |> Enum.at(position)

    if is_nil(in_position), do: :ok, else: {:error, :square_is_taken}
  end

  defp number_to_put_on_the_field(%Game{
         turn_uuid: turn_uuid,
         user_x_uuid: user_x_uuid,
         user_o_uuid: user_o_uuid
       }) do
    case turn_uuid do
      ^user_x_uuid -> 1
      ^user_o_uuid -> 0
    end
  end

  defp toggle_turn(
         %Game{turn_uuid: turn_uuid, user_x_uuid: user_x_uuid, user_o_uuid: user_o_uuid} = game
       ) do
    case turn_uuid do
      ^user_x_uuid ->
        %{game | turn_uuid: user_o_uuid}

      ^user_o_uuid ->
        %{game | turn_uuid: user_x_uuid}
    end
  end

  defp check_victory(%Game{field: field}) do
    any_row? = Enum.any?(field, &(Enum.uniq(&1) in [[0], [1]]))
    any_column? = Enum.any?(transpose(field), &(Enum.uniq(&1) in [[0], [1]]))
    flattened = List.flatten(field)

    any_diagonal? =
      [
        [Enum.at(flattened, 0), Enum.at(flattened, 4), Enum.at(flattened, 8)],
        [Enum.at(flattened, 2), Enum.at(flattened, 4), Enum.at(flattened, 6)]
      ]
      |> Enum.any?(&(Enum.uniq(&1) in [[0], [1]]))

    if any_row? or any_column? or any_diagonal?, do: :victory, else: :nope
  end

  defp check_draw(%Game{field: field}) do
    flattened = List.flatten(field)
    any_nil? = nil in Enum.uniq(flattened)
    if any_nil?, do: :nope, else: :draw
  end

  defp transpose([[] | _]), do: []

  defp transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end
end
