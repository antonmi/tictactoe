defmodule Tictactoe.Games do
  import Ecto.Query

  alias Tictactoe.{Game, Repo}

  def create(user_x_uuid, user_o_uuid) do
    %Game{}
    |> Game.changeset(%{
      user_x_uuid: user_x_uuid,
      user_o_uuid: user_o_uuid,
      turn_uuid: user_x_uuid
    })
    |> Repo.insert()
  end
end
