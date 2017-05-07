Dnevnik
=======

Static Site Generator written in Elixir 
(originally based on Benny Hallett's [Obelisk](https://github.com/BennyHallett/obelisk)).

## Creating new Dnevnik weblog

To create a new Dnevnik weblog, we use `mix new` command to create standard Elixir project

    $ mix new our_blog_name

Then we need to modify our dependencies within `mix.exs` to include Dnevnik library.

    defp deps do
      [{ :dnevnik, "~> 0.1.0" }]
    end

Next let's run the following commands to download Dnevnik and compile it

    $ mix deps.get
    $ mix deps.compile

Now we can initialise our Dnevnik weblog 
(this command will generate required folders, files, themes and default configuration)

    $ mix dnevnik setup

Let's build our Dnevnik weblog now (this command will generate final html files). 

    $ mix dnevnik build

Once our project is built, we can check it out by starting the server.

    $ mix dnevnik server

Browse to `http://localhost:4000` to see the default version of weblog.

