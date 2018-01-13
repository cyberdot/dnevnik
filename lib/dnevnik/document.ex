defmodule Dnevnik.Document do
  alias Dnevnik.{Config}
   
  def write_all(pages), do: Enum.each pages, fn page -> File.write page.path, page.document end 

  def file_name(md) do
    filepart = String.split("#{md}", "/") |> Enum.reverse |> hd
    String.replace(filepart, ".markdown", ".html")
  end

  def html_filename(md), do: "#{Config.public_directory}/#{file_name(md)}"
    
  def split_into_parts(page_content) do
    [frontmatter|content] = String.split(page_content, "}", parts: 2)
	{ Poison.Parser.parse!(String.trim(frontmatter <> "}"), keys: :atoms), Enum.join(content, "\n") }
  end
  
  def create_excerpt(content) do
	slice = content |> String.slice(0 .. 1000) 
	slice <> " ..."
 end

end
