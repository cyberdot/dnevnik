defmodule Dnevnik.Mixfile do
  use Mix.Project

  def project do
    [app: :Dnevnik,
     version: "0.1.0",
     elixir: "~> 1.0",
     docs: [readme: true, main: "README.md"],
	 package: package(),
	 deps: deps(),
     description: """
        Dnevnik is a static site generator for Elixir. It is a fork of obelisk static site generator.
     """]
  end

  def application do
    [applications: [:cowboy, :plug, :chronos],
     mod: {Dnevnik, []}]
  end

  defp deps do
    [{:poison, "~> 3.0"},
     {:earmark, "~> 0.1.15"},
     {:chronos, "~> 1.0.0"},
     {:cowboy, "~> 1.0.0"},
     {:plug, "~> 0.11.1"},
     {:rss, "~> 0.2.1"},
     {:anubis, "~> 0.1.0"},
     {:calliope, "~> 0.3.0"}]
  end

  defp package do
    %{
      licenses: ["MIT"],
      contributors: ["CyberDot"],
      links: %{ "Github" => "https://github.com/cyberdot/dnevnik"}
    }
  end
end
