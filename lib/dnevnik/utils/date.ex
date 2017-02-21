defmodule Dnevnik.Utils.Date do

  def today_as_url_part, do: Chronos.today |> Chronos.Formatter.strftime("%Y/%0m/%0d")
  
  def today, do: Chronos.today |> Chronos.Formatter.strftime("%Y-%0m-%0d") 
  
  def today_formatted, do: Chronos.today |> Chronos.Formatter.strftime("%0d %^B %Y")

  def now, do: Chronos.now |> Chronos.Formatter.strftime("%Y-%0m-%0d %H:%M:%S")
  
end
