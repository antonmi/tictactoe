defmodule Web.Router do
  use Plug.Router

  alias Web.{UserEnters, GameInfo, UserMoves}

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  plug Plug.Static,
       at: "/",
       from: :web

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/dist/index.html")
  end

  get "/js/:path" do
    conn
    |> put_resp_content_type("application/json")
    |> send_file(200, "priv/dist/js/#{conn.params["path"]}")
  end

  get "/img/:path" do
    conn
    |> put_resp_content_type("tex/css")
    |> send_file(200, "priv/dist/img/#{conn.params["path"]}")
  end

  get "/api/test" do
    send_resp(conn, 200, "It's ok")
  end

  post "/user_enters/:username" do
    result = UserEnters.call(conn.params["username"], conn.params["token"])
    send_resp(conn, 200, Jason.encode!(result))
  end

  get "/game_info/:uuid" do
    result = GameInfo.call(conn.params["uuid"])
    send_resp(conn, 200, Jason.encode!(result))
  end

  post "/user_moves/:game_uuid/:move" do
    result = UserMoves.call(conn.params["game_uuid"], conn.params["move"], conn.params["token"])
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
