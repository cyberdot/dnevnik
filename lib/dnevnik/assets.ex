defmodule Dnevnik.Assets do
  alias Dnevnik.{Theme, Config}
  
  @spec copy() :: { :ok, [binary]} | {:error, :file.posix, binary}
  def copy, do: File.cp_r("./themes/#{Theme.current}/assets", "#{Config.public_directory}/assets")
  
  @spec css() :: String.t
  def css do
    css_files()
    |> Enum.map(&("<link rel=\"stylesheet\" href=\"#{&1}\" />"))
    |> Enum.join("\n")
  end

  @spec js() :: String.t
  def js do
    js_files()
    |> Enum.map(&("<script type=\"text/javascript\" src=\"#{&1}\"></script>"))
    |> Enum.join("\n")
  end

  @spec css_files() :: list 
  defp css_files do
    File.ls!("#{Config.public_directory}/assets/css")
    |> Enum.sort
    |> Enum.map(&("assets/css/#{&1}"))
    |> Enum.filter(&(!File.dir? "#{Config.public_directory}/#{&1}"))
  end

  @spec js_files() :: list
  defp js_files do
    File.ls!("#{Config.public_directory}/assets/js")
    |> Enum.sort
    |> Enum.map(&("assets/js/#{&1}"))
    |> Enum.filter(&(!File.dir? "#{Config.public_directory}/#{&1}"))
  end
end
