defmodule Dnevnik.Sitemap do
	alias Dnevnik.{Config}
	import XmlBuilder
	
	def create() do
		get_html_files() |> generate_xml |> write_to_file
	end
	
	defp get_html_files() do
	    html_filter = fn(e) -> String.ends_with?(e, ".html") end
		root_files = Enum.filter(File.ls!(Config.public_directory), html_filter)
		tags_files = Enum.filter_map(File.ls!("#{Config.public_directory}/tags"), html_filter, &("tags/#{&1}"))
		
		root_files ++ tags_files 		
	end
		
	defp generate_xml(entries) do
	   elements = entries |> Enum.map(fn(e) -> {:url, nil, [{:loc, nil, "#{Config.data.url}/#{e}"}]} end)
	   {:urlset, %{xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9"}, elements}
	   |> doc
	   |> generate	   
	end
	
	defp write_to_file(xml) do
	    IO.puts(xml)
		File.write! "#{Config.public_directory}/sitemap.xml", xml
	end
end