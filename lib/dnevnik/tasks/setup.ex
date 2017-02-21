defmodule Dnevnik.Tasks.Setup do
  def run(_), do: Dnevnik.Site.initialize 
end
