defmodule Web.Requests.UserEntersTest do
  use Tictactoe.DataCase
  use Plug.Test

  def post_user_enters(params) do
    :post
    |> conn("/user_enters", params)
    |> Web.Router.call(%{})
  end

  test "user enters" do
    conn = post_user_enters(%{username: "anton"})

    assert conn.status == 200

    data = Jason.decode!(conn.resp_body)

    assert %{
             "token" => uuid,
             "username" => "anton",
             "game" => %{
               "field" => [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               "status" => "pending",
               "turn_uuid" => uuid,
               "uuid" => _
             },
             "user_o" => %{},
             "user_x" => %{
               "name" => "anton" <> _,
               "uuid" => uuid
             }
           } = data
  end

  test "the same user enters twice" do
    conn = post_user_enters(%{username: "anton"})

    data = Jason.decode!(conn.resp_body)
    token = data["token"]

    conn = post_user_enters(%{username: "anton", token: token})
    data = Jason.decode!(conn.resp_body)

    assert %{
             "token" => uuid,
             "username" => "anton" <> _,
             "game" => %{
               "field" => [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               "status" => "pending",
               "turn_uuid" => uuid,
               "uuid" => _
             },
             "user_o" => %{},
             "user_x" => %{
               "name" => "anton" <> _,
               "uuid" => uuid
             }
           } = data
  end

  test "2 users enter" do
    post_user_enters(%{username: "anton"})
    conn = post_user_enters(%{username: "baton"})

    assert conn.status == 200

    data = Jason.decode!(conn.resp_body)

    assert %{
             "game" => %{
               "field" => [nil, nil, nil, nil, nil, nil, nil, nil, nil],
               "status" => "active",
               "turn_uuid" => anton_uuid,
               "uuid" => _
             },
             "token" => uuid,
             "user_o" => %{
               "name" => "baton",
               "uuid" => uuid
             },
             "user_x" => %{
               "name" => "anton",
               "uuid" => anton_uuid
             }
           } = data
  end
end
