defmodule Dnevnik.Store do
  use GenServer
  alias Dnevnik.Layout
  
  def start_link do
	Agent.start_link( fn ->
      store = Map.new
      store = Map.put(store, :posts, [])
      store = Map.put(store, :pages, [])
	  store = Map.put(store, :tags, [])
	  store = Map.put(store, :layouts, %{
        layout: Layout.layout,
        post:   Layout.post,
		post_layout: Layout.post_layout,
        page:   Layout.page,
		page_layout: Layout.page_layout,
        index:  Layout.index,
		index_layout: Layout.index_layout,
		tag_layout: Layout.tag_layout,
		tag_index: Layout.tag_index
      })      
      store
    end)
  end  
 
  def add_posts(store, posts) do
    current = Agent.get(store, &Map.get(&1, :posts))
    Agent.update(store, &Map.put(&1, :posts, current ++ posts))
  end
    
  def get_posts(store) do
    Agent.get(store, &Map.get(&1, :posts))
  end
 
  def add_pages(store, pages) do
    current = Agent.get(store, &Map.get(&1, :pages))
    Agent.update(store, &Map.put(&1, :pages, current ++ pages))
  end

  def get_pages(store) do
    Agent.get(store, &Map.get(&1, :pages))
  end
 
  def get_layouts(store) do
    Agent.get(store, &Map.get(&1, :layouts))
  end 
  
  def add_tags(store, tags) do
    current = Agent.get(store, &Map.get(&1, :tags))
	Agent.update(store, &Map.put(&1, :tags, current ++ tags))
  end
  
  def get_tags(store) do
	Agent.get(store, &Map.get(&1, :tags))
  end
end
