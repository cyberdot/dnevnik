defmodule Dnevnik.Tags do
  alias Dnevnik.{Config, Posts, IndexPager, Store, Renderer, Assets, Utils.IO}
	
  def create(posts, store) do
    File.rm_rf "#{Config.public_directory}/tags"
	File.mkdir "#{Config.public_directory}/tags"
	
    tags = posts 
		|> Enum.map(fn(post) -> post.frontmatter.tags end) 
		|> List.flatten 
		|> Enum.uniq 
		|> Enum.sort
	
	tags |> create_tags_index_page(store)
	tags |> Enum.each(&render_posts_per_tag(&1,posts, store))	
  end
  
  defp create_tags_index_page(tags, store) do
	templates = Store.get_layouts(store)
	
	{ layout, layout_renderer } = templates.layout
    { index, index_renderer } = templates.tag_index
		
	index_view = Renderer.render(index, [ content: tags ], index_renderer)
	layout_model = [ 
		config: Config.data, 
		content: index_view, 
		filename: "index.html",
		css: Assets.css
	]
	File.write(Config.public_directory <> "/tags/index.html", Renderer.render(layout, layout_model, layout_renderer))
  end
  
  defp render_posts_per_tag(tag, posts, store) do
    tag_slug = IO.url_slug(tag)
    config = Config.data |> Map.update(:blog_index, "tags/#{tag_slug}.html", fn _ -> "tags/#{tag_slug}.html" end)
    posts 
		|> Enum.filter(fn(post) -> Enum.any?(post.frontmatter.tags, &(&1 == tag)) end) 
		|> create_index_per_tag(tag, store, config)
  end 
  
  defp create_index_per_tag(posts, tag, store, config) do
	posts |> Posts.sort_by_date |> compile_index(tag, store, config)
  end
    
  defp compile_index(posts, tag, store, config, page_num \\ 1)
  defp compile_index([], _, _, _, _), do: nil
  defp compile_index(posts, tag, store, config, page_num) do
    { posts_per_page, remainder } = Enum.split(posts, config.posts_per_page)
    write_index_page posts_per_page, tag, config, page_num, IndexPager.last_page?(remainder), store
    compile_index remainder, store, config, page_num + 1
  end
    
  defp write_index_page(posts, tag, config, page_num, is_last_page, store) do
    templates = Store.get_layouts(store)
    { layout, layout_renderer } = templates.tag_layout
    { index, index_renderer } = templates.index
	
	index_model = create_index_view_model(page_num, config, is_last_page, posts)
	index_view = Renderer.render(index, index_model, index_renderer)
    
	layout_model = create_layout_view_model(index_view, config, tag)
	File.write(html_filename(page_num, config), Renderer.render(layout, layout_model, layout_renderer))
  end
  
  defp create_index_view_model(page_num, config, is_last_page, posts) do
	[   
		current: page_num, 
		prev: IndexPager.previous_page(page_num, config), 
		next: IndexPager.next_page(page_num, is_last_page, config), 
		content: posts, 
		config: config 
	]
  end
  
  defp create_layout_view_model(content, config, tag) do
	[ config: config, js: Assets.js, css: Assets.css, content: content, tag: tag, path: "", filename: ""]
  end
  
  def html_filename(page_num, config) do
    config |> Map.get(:blog_index) |> IndexPager.with_index_num(page_num) |> build_index_path
  end
  
  defp build_index_path({_, path}), do: Config.public_directory <> "/" <> path
  
end