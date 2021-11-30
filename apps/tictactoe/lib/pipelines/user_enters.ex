defmodule Tictactoe.Pipelines.UserEnters do
  use ALF.DSL

  alias Tictactoe.{Game, Move}

  defstruct username: "",
            token: nil,
            users_with_the_name: []

  @components [
    switch(:token_present?,
      branches: %{
        yes: [],
        no: [
          stage(:find_users_with_the_name)
        ]
      }
    )
  ]

  def token_present?(%__MODULE__{token: nil}, _opts), do: :no
  def token_present?(%__MODULE__{token: _token}, _opts), do: :yes

  def find_users_with_the_name(event, _opts) do
    event
  end
end
