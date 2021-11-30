defmodule Tictactoe.Users do
  import Ecto.Query

  alias Tictactoe.{User, Repo}

  @spec create(String.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(name) do
    %User{}
    |> User.changeset(%{name: name})
    |> Repo.insert()
  end
end
