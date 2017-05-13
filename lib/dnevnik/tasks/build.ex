defmodule Dnevnik.Tasks.Build do
  alias Dnevnik.{Site, Theme, Assets, Tags, Page, Post, Document, RSS, Index, Store, Sitemap}
  
  def run(_) do
    Dnevnik.start(nil, nil)
	Site.prepare
	Theme.ensure
	Assets.copy     

    { :ok, store } = Store.start_link
		
	Page.list |> Enum.each(&(Page.prepare(&1, store)))
    Post.list |> Enum.each(&(Post.prepare(&1, store)))
		
    Document.write_all Store.get_pages(store)
    
	posts = Store.get_posts(store)
	posts |> Tags.create(store)
	posts |> Document.write_all
	posts |> RSS.build_feed
    posts |> Index.create(store)
	
	Sitemap.create()
  end

end
