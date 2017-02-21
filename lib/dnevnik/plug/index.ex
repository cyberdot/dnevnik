defmodule Dnevnik.Plug.Index do
   @behaviour Plug
   require Dnevnik.Config
   
   def init(opts), do: opts
   
   def call(%Plug.Conn{path_info: [], state: state} = conn, _opts) when state in [:unset, :set] do
     path = Path.expand("#{Dnevnik.Config.public_directory}/index.html")
     if File.exists? path do
       conn
         |> Plug.Conn.send_file(200, path)
         |> Plug.Conn.halt
     else
       conn
     end
   end
   def call(conn, _opts), do: conn
 end
