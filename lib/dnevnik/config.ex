defmodule Dnevnik.Config do
    
  @content_directory "./_content"
  @public_directory "./_public"
  @config_file "config.json"
  
  @spec content_directory() :: String.t
  def content_directory, do: @content_directory 
  
  @spec public_directory() :: String.t
  def public_directory, do: @public_directory

  @spec init() :: :ok | {:error, :file.posix}
  def init, do: File.write '#{@content_directory}/#{@config_file}', default()  
  
  @spec data() :: map
  def data, do: load_config(File.read("#{@content_directory}/#{@config_file}"))
    
  @spec load_config(t :: { :error, :file.posix}) :: map
  defp load_config({ :error, _ }), do: { :ok, default() } |> load_config
  
  @spec load_config(t :: { :ok, binary}) :: map
  defp load_config({ :ok, content }), do: Poison.Parser.parse!(content, keys: :atoms) 
  
  @spec default() :: binary
  defp default do
    """
    {
      "name": "A brand new static site",
      "author": "author_name",
      "author_description": "Author's description, skills, etc",
      "author_location": "Location",
      "url": "http://localhost:4000",
      "description": "Your site description",
      "language": "en-gb",
      "posts_per_page": 10,
      "sort_posts": "ascending",
      "theme": "whisper",
	  
	  "github": "github_account_name",
	  	  
      "disqus_url": "disqus_username.disqus.com",
      "enable_disqus_comments": true  
    }      
    """
  end  
end
