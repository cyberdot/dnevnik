defmodule Dnevnik.Layout do
  alias Dnevnik.{Theme, Config}

  def path, do: "#{Config.content_directory}/themes/#{Theme.current}/layout/layout.eex"
  
  def layout, do: load "layout"
  
  def post, do: load "post"
  def post_layout, do: resolve_layout "post_layout"
  
  def page, do: load "page"
  def page_layout, do: resolve_layout "page_layout"
  
  def index, do: load "index"
  def index_layout, do: resolve_layout "index_layout"
  
  def tag_layout, do: resolve_layout "tag_layout"  
  
  defp resolve_layout(template), do: load template, "layout"
  
  defp load(template, fallback \\ nil) do
    filep = template |> to_filename |> to_path
	filep |> read(fallback) |> determine_renderer
  end
  
  defp base_path, do: "#{Config.content_directory}/themes/#{Theme.current}/layout"

  defp to_path(nil), do: nil
  defp to_path(filename), do: base_path() <> "/" <> filename
  
  defp read(path, nil), do: { File.read!(path), path}
  defp read(nil, fallback), do: fallback |> to_filename |> to_path |> read(nil) 
  defp read(path, _fallback), do: read(path, nil)
  
  defp to_filename(template) do
    base_path()
    |> File.ls!
    |> Enum.find(fn(t) -> Path.basename(t, ".eex") == template end)
  end
  
  defp determine_renderer({ content, path }) do
    renderer = path |> Path.extname |> String.trim_leading(".") |> String.to_atom
    { content, renderer }
  end
end
