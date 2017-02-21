defmodule Dnevnik.Post do
  alias Dnevnik.{Config, Document, Store, Utils.IO}
    
  def init do
	File.mkdir "#{Config.content_directory}/posts"
	create("Welcome to Dnevnik")
  end
  
  def create(title, is_draft \\ false) do
	case is_draft do
		true -> "#{Config.content_directory}/drafts"
		false -> "#{Config.content_directory}/posts"
	end |> IO.filename_from_title(title) |> File.write(default(title))
  end
   
  def prepare(md_file, store) do
    layouts = Store.get_layouts(store)
	Store.add_posts(store, [ Document.prepare("#{Config.content_directory}/posts/#{md_file}", layouts.post, layouts.post_layout) ])
  end
  
  def list, do: File.ls!("#{Config.content_directory}/posts") |> Enum.sort |> Enum.reverse
  
  defp default(title) do
	
    """
    
	{
		"title": "#{title}",
		"description": "A new blog post",
		"created": "#{Dnevnik.Utils.Date.today_formatted}",
		"tags": ["post", "new"],
		"slug": "#{IO.url_slug_from_title(title)}"
	}
	
   
    Welcome to your brand new Dnevnik post.
    """
  
  end
end
