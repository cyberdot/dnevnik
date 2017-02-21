defmodule Dnevnik.Tags do
  alias Dnevnik.{Index, Config}
	
  def prepare_using(posts, store) do
    File.rm_rf "#{Config.public_directory}/tags"
	File.mkdir "#{Config.public_directory}/tags"
	
    posts 
		|> Enum.map(fn(post) -> post.frontmatter.tags end) 
		|> List.flatten 
		|> Enum.uniq 
		|> Enum.each(&prepare_tag(&1,posts, store))	
  end
  
  def prepare_tag(tag, posts, store) do
    config = Config.data |> update_config(tag)
	posts |> Enum.filter(fn(post) -> Enum.any?(post.frontmatter.tags, &(&1 == tag)) end) |> Index.create(store, config)
  end
  
  defp update_config(config, tag) do
	Map.update(config, :name, tag, fn _ -> tag end) 
		|> Map.update(:description, "tagged collection of posts", fn _ -> "tagged collection of posts" end)
		|> Map.update(:blog_index, "tags/#{tag}.html", fn _ -> "tags/#{tag}.html" end)	
  end
  
end