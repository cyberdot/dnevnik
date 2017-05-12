defmodule Dnevnik.Draft do
  alias Dnevnik.{Config, Post}
  
  @spec init() :: :ok | {:error, :file.posix}
  def init, do: File.mkdir "./drafts" 
  
  @spec create(title :: binary) :: :ok | {:error, :file.posix}
  def create(title), do: Post.create(title, true)
  
  @spec list() :: [binary] | no_return
  def list, do: File.ls! "./drafts"  
 
end
