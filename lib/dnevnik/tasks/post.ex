defmodule Dnevnik.Tasks.Post do
  def run([]), do: raise ArgumentError, message: "Cannot create a new post without the post name" 
  def run(args), do: hd(args) |> Dnevnik.Post.create 
end
