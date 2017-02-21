defmodule Dnevnik.Tasks.Draft do
  def run([]), do: raise ArgumentError, message: "Cannot create a new draft without the post name"  
  def run(args), do: hd(args) |> Dnevnik.Draft.create
end
