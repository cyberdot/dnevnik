defmodule Dnevnik.Plug.Server do
  
  use Plug.Builder

  plug Plug.Static, at: "/", from: "_public"
  plug Dnevnik.Plug.Index
  plug :not_found

  
  def not_found(conn, _) do
    Plug.Conn.send_resp(conn, 404, "Resource not found. If you're looking for the index page, try http://localhost:4000/")
  end
end
