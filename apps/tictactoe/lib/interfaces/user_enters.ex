defmodule Tictactoe.Interfaces.UserEnters do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.UserEnters

  def call(username, token) do

    case %UserEnters{username: username, token: token}
         |> Tictactoe.EventPool.process_event()
      do
      {:ok, event} ->
        {:ok, event.game_data}
      {:error, :error} ->
        {:error, :error}
    end
  end
end
