defmodule Dnevnik.IndexPager do
  alias Dnevnik.{Config}

  def next_page(page_num, is_last, config \\ Config.data)
  def next_page(_, true, _),  do: { 0, "" }  
  def next_page(page_num,  false, config), do: config |> Map.get(:blog_index) |> with_index_num(page_num + 1) 
  
  def previous_page(page_num, config \\ Config.data)  
  def previous_page(1, _), do: { 0, "" }
  def previous_page(page_num, config), do: config |> Map.get(:blog_index) |> with_index_num(page_num - 1)
  
  def total_pages(posts_count), do: trunc(Float.ceil(posts_count / Config.data.posts_per_page))
  
  def with_index_num(nil, 1), do: {1, "index.html"}
  def with_index_num(nil, page_num), do: {page_num, "index#{page_num}.html"}
  def with_index_num(c, 1), do: {1, c}
  def with_index_num(c, page_num) do
    {root, ext} = { Path.rootname(c), Path.extname(c) }
	{page_num, "#{root}#{page_num}.#{ext}"}
  end
  
  def last_page?([]), do: true
  def last_page?(_),  do: false

end