defmodule Tictactoe.Interfaces.UserEnters do
  alias Tictactoe.EventPool
  alias Tictactoe.Pipelines.UserEnters

  def call(username, token) do
    case EventPool.process_event(%UserEnters{username: username, token: token}) do
      {:ok, event} ->
        {:ok, Map.put(event.game_data, :token, event.token)}

      {:error, :error} ->
        {:error, :error}
    end
  end
end
