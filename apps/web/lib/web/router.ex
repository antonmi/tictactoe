defmodule Web.Router do
  use Plug.Router

  alias Web.{UserEnters}

  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "world")
  end

  post "/user_enters/:username" do
    result = UserEnters.call(conn.params["username"], nil)
    send_resp(conn, 200, Jason.encode!(result))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
