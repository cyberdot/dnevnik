defmodule Dnevnik.Utils.IO do
    
	def ensure_directory(dir), do: File.mkdir dir
	
	def filename_from_title(directory, title) do
		title |> String.downcase |> String.replace(" ", "-") 
			  |> (fn(title_part) -> "#{directory}/#{title_part}.markdown" end).()
	end
	
	def url_slug_from_title(title), do: title |> String.downcase |> String.replace(" ", "-")	
end