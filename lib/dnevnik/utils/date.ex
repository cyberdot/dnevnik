defmodule Dnevnik.Utils.Date do
  
  def today, do: Chronos.today |> Chronos.Formatter.strftime("%Y-%0m-%0dT%H:%M:%SZ") 
    
  def now, do: Chronos.now |> Chronos.Formatter.strftime("%Y-%0m-%0dT%H:%M:%SZ")
  
  def parse(input) do
	{:ok, date, _} = DateTime.from_iso8601(input)
	date
  end
end
