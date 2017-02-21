defmodule Mix.Tasks.D do
  use Anubis
  
  command :setup,   	"Create the scaffolding for the static site", 		Dnevnik.Tasks.Setup.run
  command :build,  		"Compile the site to the root weblog directory",   	Dnevnik.Tasks.Build.run
  command :page,		"Create new page",									Dnevnik.Tasks.Page.run
  command :post,   		"Create a new post",                           		Dnevnik.Tasks.Post.run
  command :draft,  		"Create a new draft",                          		Dnevnik.Tasks.Draft.run
  command :server, 		"Start a local server to view the blog",       		Dnevnik.Tasks.Server.run
  command :reload, 	    "Recompile the site and start local server",   		Dnevnik.Tasks.Reload.run
  parse()
end
