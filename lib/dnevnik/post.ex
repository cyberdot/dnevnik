defmodule Dnevnik.Post do
  alias Dnevnik.{Config, Document, Assets, Store, Renderer, Utils.IO, Utils.Date}
    
  def init do
	File.mkdir "#{Config.content_directory}/posts"
	create("Welcome to Dnevnik")
  end
  
  def list, do: File.ls!("#{Config.content_directory}/posts") |> Enum.sort |> Enum.reverse
    
  def create(title, is_draft \\ false) do
	case is_draft do
		true -> "#{Config.content_directory}/drafts"
		false -> "#{Config.content_directory}/posts"
	end |> IO.filename_from_title(title) |> File.write(default(title))
  end
   
  def prepare(md_file, store) do
    post = store |> Store.get_layouts |> prepare_page("#{Config.content_directory}/posts/#{md_file}")
	Store.add_posts(store, [post])
  end
  
  defp prepare_page(layouts, md_file) do
	{ frontmatter, md_content } =  md_file |> File.read! |> Document.split_into_parts 
	
	content = Earmark.to_html(md_content)
	filename = Document.file_name(md_file)
	html_path = Document.html_filename(md_file)
	excerpt = Document.create_excerpt(content)
	
	{page_layout, page_renderer} = layouts.post
	{layout_template, layout_renderer} = layouts.post_layout
	
	content = Renderer.render(page_layout, [ 
			config: Config.data, 
			content: content, 
			frontmatter: frontmatter, 
			filename: filename, 
			path: html_path 
		], page_renderer)
	
	view_model = [ 
		config: Config.data, 
		js: Assets.js, 
		css: Assets.css, 
		content: content, 
		frontmatter: frontmatter, 
		filename: filename, 
		path: html_path 
	]
    
    document = Renderer.render(layout_template, view_model, layout_renderer)
	%{ 
		date_created: Date.parse(frontmatter.created), 
		frontmatter: frontmatter, 
		document: document, 
		path: html_path, 
		filename: filename, 
		excerpt: excerpt, 
		config: Config.data 
	}
  end
  
  defp default(title) do
	
    """
    
	{
		"title": "#{title}",
		"description": "A new blog post",
		"created": "#{Dnevnik.Utils.Date.today}",
		"tags": ["post", "new"],
		"slug": "#{IO.url_slug(title)}"
	}
	
   
    Welcome to your brand new Dnevnik post.
    """
  
  end
end
