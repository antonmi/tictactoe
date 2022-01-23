defmodule Web.Router do
  use Plug.Router

  alias Web.{UserEnters, GameInfo}

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "world")
  end

  post "/user_enters/:username" do
    result = UserEnters.call(conn.params["username"], conn.params["token"])
    send_resp(conn, 200, Jason.encode!(result))
  end

  get "/game_info/:uuid" do
    result = GameInfo.call(conn.params["uuid"])
    send_resp(conn, 200, Jason.encode!(result))
  end

  #  post "/user_enters/:username" do
  #    result = UserEnters.call(conn.params["username"], nil)
  #    send_resp(conn, 200, Jason.encode!(result))
  #  end

  match _ do
    send_resp(conn, 404, "NOT FOUND")
  end
end
