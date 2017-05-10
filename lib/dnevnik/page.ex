defmodule Dnevnik.Page do
  alias Dnevnik.{Config, Assets, Document, Renderer, Store, Utils.IO, Utils.Date}
  
  def init do
	File.mkdir pages_dir()
	create("About")
  end
  
  def list, do: File.ls! pages_dir()
  
  def create(title), do: pages_dir() |> IO.filename_from_title(title) |> File.write(default(title))  

  def prepare(md_file, store) do
    store |> Store.add_pages([ prepare_page("#{pages_dir()}/#{md_file}", Store.get_layouts(store)) ])
  end
  
  defp pages_dir, do: "#{Config.content_directory}/pages"

  defp prepare_page(file_path, layouts) do
	{ layout_template, layout_renderer } = layouts.page_layout
	{ page_template, page_renderer} = layouts.page
	{ frontmatter, content } =  file_path |> File.read! |> Document.split_into_parts 
	
	filename = Document.file_name(file_path)
	path = Document.html_filename(file_path)
	
	content = Renderer.render(page_template, page_view_model(content, frontmatter, filename), page_renderer)
	document = Renderer.render(layout_template, layout_view_model(content, frontmatter, path, filename), layout_renderer)
	
	%{ document: document, path: path }
  end  
  
  defp page_view_model(content, frontmatter, filename) do
	[ config: Config.data, content: Earmark.to_html(content), frontmatter: frontmatter, filename: filename ]
  end
  
  defp layout_view_model(content, frontmatter, path, filename) do
	[ 
		config: Config.data, 
		js: Assets.js, 
		css: Assets.css, 
		content: content, 
		frontmatter: frontmatter, 
		path: path, 
		filename: filename 
	]
  end
  
  def default(title) do
    """ 
	{ 
	  "title": "#{title}", 
	  "description": "A new page", 
	  "created": "#{Date.today}", 
	  "tags": ["page", "new"], 
	  "slug": "#{IO.url_slug_from_title(title)}"
	}

    Welcome to your brand new page.
    """
  end
end
