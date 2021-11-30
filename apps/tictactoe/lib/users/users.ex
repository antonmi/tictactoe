defmodule Tictactoe.Users do
  import Ecto.Query

  alias Tictactoe.{User, Repo}

  @spec create(String.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(name) do
    %User{}
    |> User.changeset(%{name: name})
    |> Repo.insert()
  end

  def where_name_starts_with(name) do
    like = "#{name}%"

    Repo.all(from u in User, where: ilike(u.name, ^like))
  end
end
