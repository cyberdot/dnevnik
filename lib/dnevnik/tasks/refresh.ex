defmodule Dnevnik.Tasks.Refresh do
	def run(args) do
		Dnevnik.Tasks.Build.run(args)
		Dnevnik.Tasks.Server.run(args)
	end
end