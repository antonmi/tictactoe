defmodule Tictactoe.Pipelines.UserEntersTest do
  use Tictactoe.DataCase

  alias Tictactoe.{Games, Users}
  alias Tictactoe.Pipelines.UserEnters
  alias ALF.Manager

  setup do
    Manager.start(UserEnters)
  end

  def process_event(event) do
    [result] =
      [event]
      |> Manager.stream_to(UserEnters)
      |> Enum.to_list()

    result
  end

  describe "new user without token/uuid" do
    setup do
      %{event: %UserEnters{username: "john"}}
    end

    test "it creates a new user and a game", %{event: event} do
      result = process_event(event)

      assert result.user.name == "john"
      assert result.game
      game_data = result.game_data
      assert game_data[:game]
      assert game_data[:user_x]
      assert game_data[:user_o] == %{}
    end
  end

  describe "new user without token and with invalid name" do
    setup do
      %{event: %UserEnters{username: ""}}
    end

    test "it creates a new user and a game", %{event: event} do
      result = process_event(event)

      assert result.error == :invalid_input
    end
  end

  describe "new user with existing name" do
    setup do
      Users.create("john")
      %{event: %UserEnters{username: "john"}}
    end

    test "it creates a new user with postix", %{event: event} do
      result = process_event(event)

      assert result.user.name == "john_1"
      assert result.game
      game_data = result.game_data
      assert game_data[:game]
      assert game_data[:user_x]
      assert game_data[:user_o] == %{}
    end
  end

  describe "new user and there is a free game" do
    setup do
      {:ok, user} = Users.create("jack")
      {:ok, game} = Games.create(user.uuid, nil)
      %{event: %UserEnters{username: "john"}, game: game}
    end

    test "it creates a new user find existing game for him", %{event: event, game: game} do
      result = process_event(event)

      assert result.user.name == "john"
      assert result.game.uuid == game.uuid
      game_data = result.game_data
      assert game_data[:game]
      assert game_data[:user_x][:name] == "jack"
      assert game_data[:user_o][:name] == "john"
    end
  end

  describe "existing user enters with uuid and there is no game for him" do
    setup do
      {:ok, user} = Users.create("john")
      %{event: %UserEnters{token: user.uuid}}
    end

    test "it finds the user and creates a new game", %{event: event} do
      result = process_event(event)

      assert result.user.name == "john"
      assert result.game
      game_data = result.game_data
      assert game_data[:game][:status] == "pending"
      assert game_data[:user_x]
      assert game_data[:user_o] == %{}
    end
  end

  describe "there is no such user" do
    setup do
      {:ok, _user} = Users.create("john")
      %{event: %UserEnters{token: Ecto.UUID.generate()}}
    end

    test "it finds the user and creates a new game", %{event: event} do
      result = process_event(event)

      assert result.error == :no_such_user
    end

    test "when token is not uuid" do
      result = process_event(%UserEnters{token: "invalid_token"})

      assert result.error == :no_such_user
    end
  end

  describe "existing user enters with uuid and there is a pending game" do
    setup do
      {:ok, user} = Users.create("john")
      {:ok, game} = Games.create(user.uuid, nil)
      %{event: %UserEnters{token: user.uuid}, game: game}
    end

    test "it finds the user and his game", %{event: event, game: game} do
      result = process_event(event)

      assert result.user.name == "john"
      assert result.game
      game_data = result.game_data
      assert game_data[:game][:uuid] == game.uuid
      assert game_data[:game][:status] == "pending"
      assert game_data[:user_x][:name] == "john"
      assert game_data[:user_o] == %{}
    end
  end

  describe "existing user enters with uuid and there is an active game" do
    setup do
      {:ok, user} = Users.create("john")
      {:ok, another_user} = Users.create("jack")
      {:ok, game} = Games.create(another_user.uuid, user.uuid)

      %{event: %UserEnters{token: user.uuid}, game: game}
    end

    test "it finds the user and his game", %{event: event, game: game} do
      result = process_event(event)

      assert result.user.name == "john"
      assert result.game
      game_data = result.game_data
      assert game_data[:game][:uuid] == game.uuid
      assert game_data[:game][:status] == "active"
      assert game_data[:user_x][:name] == "jack"
      assert game_data[:user_o][:name] == "john"
    end
  end
end
