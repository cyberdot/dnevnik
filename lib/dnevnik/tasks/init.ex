defmodule Dnevnik.Tasks.Init do
  def run(_), do: Dnevnik.Site.initialize 
end
