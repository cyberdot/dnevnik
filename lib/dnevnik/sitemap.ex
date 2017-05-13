defmodule Dnevnik.Sitemap do
	alias Dnevnik.{Config}
	import XmlBuilder
	
	def create(items) do
		items 
		|> generate_posts
		|> generate_pages
		|> generate_tags
		|> to_xml_string
		|> write_to_file
	end
	
	defp generate_posts({posts, pages, tags}) do
	    posts_xml = posts |> Enum.map(fn(p) -> {:url, nil, [{:loc, nil, "#{Config.data.url}/#{p.filename}"}]} end)
		{pages, tags, posts_xml}
	end
	
	defp generate_pages({pages, tags, posts_xml}) do
		pages_xml = pages |> Enum.map(fn(p) -> {:url, nil, [{:loc, nil, "#{Config.data.url}/#{p.filename}"}]} end)
		{tags, posts_xml, pages_xml}
	end
	
	defp generate_tags({tags, posts_xml, pages_xml}) do
		tags_xml = tags |> Enum.map(fn(t) -> {:url, nil, [{:loc, nil, "#{Config.data.url}/tags/#{t}.html"}]} end)
		{posts_xml, pages_xml, [{:url,nil, [{:loc, nil, "#{Config.data.url}/tags/index.html"}] ++ tags_xml}]}
	end
	
	defp to_xml_string({posts, pages, tags}) do
	   {:urlset, %{xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9"}, posts ++ pages ++ tags}
	   |> doc
	   |> generate	   
	end
	
	defp write_to_file(xml) do
	    IO.puts(xml)
		File.write! "#{Config.public_directory}/sitemap.xml", xml
	end
end