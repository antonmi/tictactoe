defmodule Tictactoe.EventPool do
  use GenServer

  alias ALF.Manager.Client

  defstruct []

  @timeout 60_000

  def start_link(_args)  do
    GenServer.start_link(__MODULE__, %__MODULE__{})
  end

  @impl true
  def init(%__MODULE__{}) do
    {:ok, %__MODULE__{}}
  end

  def process_event(event) do
    :poolboy.transaction(
      :event_sink,
      fn pid ->
        GenServer.call(pid, {:process_event, event})
      end,
      @timeout
    )
  end

  @impl true
  def handle_call({:process_event, event}, _from, state) do
    {:reply, do_process_event(event), state}
  end

  defp do_process_event(%{__struct__: pipeline} = event) do
    {:ok, pid} = Client.start(pipeline)
    case Client.call(pid, event) do
      %ALF.ErrorIP{} = error_event ->
        IO.inspect(error_event)
        Client.stop(pid)
        {:error, :error}
      event ->
        Client.stop(pid)
        {:ok, event}
    end

  end
end
