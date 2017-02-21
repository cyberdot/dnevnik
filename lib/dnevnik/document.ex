defmodule Dnevnik.Document do
  alias Dnevnik.{Assets, Config, Renderer}
    
  def prepare(md_file, {template, renderer}, {layout_template, layout_renderer}) do
    { frontmatter, md_content } =  md_file |> File.read! |> split_into_parts 
	filename = file_name(md_file)
	html_path = html_filename(md_file)
	
	content = Renderer.render(template, [ config: Config.data, content: Earmark.to_html(md_content), frontmatter: frontmatter, filename: filename, path: html_path ], renderer)
	excerpt = create_excerpt(md_content)
	assigns = [ config: Config.data, js: Assets.js, css: Assets.css, content: content, frontmatter: frontmatter, filename: filename, path: html_path ]
    
    document = Renderer.render(layout_template, assigns, layout_renderer)
	%{ frontmatter: frontmatter, content: content, document: document, path: html_path, filename: filename, excerpt: excerpt, config: Config.data }
  end
  
  def write_all(pages), do: Enum.each pages, fn page -> File.write page.path, page.document end 

  def file_name(md) do
    filepart = String.split("#{md}", "/") |> Enum.reverse |> hd
    String.replace(filepart, ".markdown", ".html")
  end

  def html_filename(md), do: "#{Config.public_directory}/#{file_name(md)}"
    
  def split_into_parts(page_content) do
    [frontmatter|content] = String.split page_content, "\n}\n"
	{ Poison.Parser.parse!(String.trim(frontmatter <> "\n}\n"), keys: :atoms), Enum.join(content, "\n") }
  end
  
  defp create_excerpt(content) do
	content |> String.slice(0 .. 100)
  end

end
