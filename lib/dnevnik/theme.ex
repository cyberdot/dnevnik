defmodule Dnevnik.Theme do
   alias Dnevnik.{Config, Errors, Utils.Git, Utils.IO}
   
  def init do
   themes_dir = IO.resolve("themes")
   File.mkdir "#{Config.content_directory}/themes"
   File.cp_r themes_dir, "#{Config.content_directory}/themes"
  end
    
  def ensure, do: Config.data |> Map.get(:theme) |> String.split("/") |> _ensure  
  
  def current, do: Config.data|> Map.get(:theme) |> String.split("/") |> _current
  defp _current([local]), do: local
  defp _current([_user, repo]), do: repo
  defp _current(url), do: url |> Enum.reverse |> hd |> String.replace("\.git", "")

  defp _ensure([local]), do: ensure_local(File.dir?("#{Config.content_directory}/themes/#{local}"), local)
  defp _ensure([user, repo]), do: ensure_github(File.dir?("#{Config.content_directory}/themes/#{repo}"), user, repo)
  defp _ensure(url), do: ensure_url(url)

  defp ensure_local(true, _theme), do: true
  defp ensure_local(false, theme), do: raise(Errors.ThemeNotFound, {:local, theme})
 
  defp ensure_github(true, _user, _repo), do: true
  defp ensure_github(false, user, repo), do: "https://github.com/#{user}/#{repo}.git" |> Git.clone 

  defp ensure_url(url) do
    repo = url
    |> Enum.reverse
    |> hd
    |> String.replace("\.git", "")

    _ensure_url(File.dir?("#{Config.content_directory}/themes/#{repo}"), Enum.join(url, "/"))
  end

  def _ensure_url(true, _url), do: true
  def _ensure_url(false, url), do: url |> Git.clone

end
