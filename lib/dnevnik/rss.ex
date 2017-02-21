defmodule Dnevnik.RSS do
  alias Dnevnik.{Config, Utils.Date}

  @spec build_feed(posts :: [map]) :: :ok | {:error, :file.posix}
  def build_feed(posts) do
    config = Config.data
    channel = RSS.channel(
      Map.get(config, "name"),
      Map.get(config, "url"),
      Map.get(config, "description"),
      Date.now,
      Map.get(config, "language", "en-gb"))
	  
    File.write("#{Config.public_directory}/blog.rss", RSS.feed(channel, compile_rss(posts)))
  end
  
  @spec compile_rss(posts :: [map]) :: [binary]
  defp compile_rss(posts), do: posts |> Enum.map(&(build_item &1))
   
  @spec build_item(post :: map) :: binary
  defp build_item(post) do
    config = Config.data
    url = Map.get(config, "url", "") <> "/" <> post.filename
    RSS.item(
      Map.get(post.frontmatter, :title),
      Map.get(post.frontmatter, :description),
      String.slice(post.filename, 0, 10),
      url, url)
  end

end
