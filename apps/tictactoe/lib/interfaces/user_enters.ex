defmodule Tictactoe.Interfaces.UserEnters do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.UserEnters

  def call(username, token) do
    case EventPool.process_event(%UserEnters{username: username, token: token}) do
      {:ok, event} ->
        {:ok, event.game_data}
      {:error, :error} ->
        {:error, :error}
    end
  end
end
