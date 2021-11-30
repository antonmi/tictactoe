defmodule Tictactoe.Application do
  use Application

  alias Tictactoe.Repo

  @impl true
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Assistant.Supervisor]

    Supervisor.start_link([Repo], opts)
  end
end
