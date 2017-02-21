defmodule Dnevnik.Site do
  alias Dnevnik.{Config, Theme, Draft, Page, Post}
  
  def initialize do
    clean()
    copy_root_files()	
	Config.init
    Theme.init 
	Draft.init
	Page.init
    Post.init    
  end
  
  def prepare do
	File.rm_rf "#{Config.public_directory}"
	File.mkdir "#{Config.public_directory}"
	
	File.cp "#{Config.content_directory}/robots.txt", "#{Config.public_directory}/robots.txt"
	File.cp "#{Config.content_directory}/CNAME", "#{Config.public_directory}/CNAME"
  end

  def clean do
    File.rm_rf "#{Config.content_directory}"
    File.mkdir "#{Config.content_directory}"
	
	File.rm_rf "#{Config.public_directory}"
    File.mkdir "#{Config.public_directory}"
  end
  
  defp copy_root_files do
    File.cp "./robots.txt", "#{Config.content_directory}/robots.txt"
    File.cp "./CNAME", "#{Config.content_directory}/CNAME"
  end
end
