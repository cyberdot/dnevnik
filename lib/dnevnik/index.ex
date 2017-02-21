defmodule Dnevnik.Index do
  require Integer
  alias Dnevnik.{Config, Store, Renderer, Assets, Posts, IndexPager}
 
  @spec create(posts :: [ ... ], store :: pid) :: nil
  def create(posts, store, config \\ Config.data), do: posts |> Posts.sort_by_date |> compile_index(store, config)
    
  defp compile_index(posts, store, config, page_num \\ 1)
  defp compile_index([], _, _, _), do: nil
  defp compile_index(posts, store, config, page_num) do
    { posts_per_page, remainder } = Enum.split(posts, config.posts_per_page)
    write_index_page posts_per_page, config, page_num, IndexPager.last_page?(remainder), store
    compile_index remainder, store, config, page_num + 1
  end
    
  defp write_index_page(posts, config, page_num, is_last_page, store) do
    templates = Store.get_layouts(store)
    { layout, layout_renderer } = templates.index_layout
    { index, index_renderer } = templates.index
	
	index_model = create_index_view_model(page_num, config, is_last_page, posts)
	index_view = Renderer.render(index, index_model, index_renderer)
    
	layout_model = create_layout_view_model(index_view, config)
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
  
  defp create_layout_view_model(content, config) do
	[ config: config, js: Assets.js, css: Assets.css, content: content]
  end
  
  def html_filename(page_num, config) do
    config |> Map.get(:blog_index) |> IndexPager.with_index_num(page_num) |> build_index_path
  end
  
  defp build_index_path({_, path}), do: Config.public_directory <> "/" <> path
end
