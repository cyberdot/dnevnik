defmodule Dnevnik.Tasks.Page do
  def run([]), do: raise(ArgumentError, message: "Cannot create a new page without the post name")
  def run(args), do: hd(args) |> Dnevnik.Page.create
end
