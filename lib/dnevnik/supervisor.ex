defmodule Dnevnik.Supervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, :ok)
 
  def init(:ok) do
    children = [ worker(Dnevnik.Store, []) ]
    supervise(children, strategy: :one_for_one)
  end
end
