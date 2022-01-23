defmodule Tictactoe.EventPool do
  def process_event(%{__struct__: pipeline} = event) do
    [event]
    |> ALF.Manager.stream_to(pipeline)
    |> Enum.to_list()
    |> case do
      [%ALF.ErrorIP{} = error_event] ->
        IO.inspect(error_event)
        {:error, :error}

      [event] ->
        {:ok, event}
    end
  end
end
