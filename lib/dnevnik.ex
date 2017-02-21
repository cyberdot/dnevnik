defmodule Dnevnik do
  use Application
  def start(_type, _args), do: Dnevnik.Supervisor.start_link 
end
