defmodule Dnevnik.Assets do
  alias Dnevnik.{Theme, Config}
  
  @spec copy() :: { :ok, [binary]} | {:error, :file.posix, binary}
  def copy, do: File.cp_r("#{Config.content_directory}/themes/#{Theme.current}/assets", "#{Config.public_directory}/assets")
  
  @spec css() :: String.t
  def css do
    css_dir = "#{Config.public_directory}/assets/css"
	case File.exists?(css_dir) do
		true -> css_files(css_dir) |> Enum.map(&("<link rel=\"stylesheet\" href=\"#{&1}\" />")) |> Enum.join("\n")
		false -> ""
	end
  end

  @spec js() :: String.t
  def js do
    js_dir = "#{Config.public_directory}/assets/js"
	case File.exists?(js_dir) do
		true -> js_files(js_dir) |> Enum.map(&("<script type=\"text/javascript\" src=\"#{&1}\"></script>")) |> Enum.join("\n")
		false -> ""
	end
  end

  @spec css_files(css_dir :: String.t) :: list 
  defp css_files(css_dir) do
    File.ls!(css_dir)
    |> Enum.sort
    |> Enum.map(&("assets/css/#{&1}"))
    |> Enum.filter(&(!File.dir? "#{Config.public_directory}/#{&1}"))
  end

  @spec js_files(js_dir :: String.t) :: list
  defp js_files(js_dir) do
    File.ls!(js_dir)
    |> Enum.sort
    |> Enum.map(&("assets/js/#{&1}"))
    |> Enum.filter(&(!File.dir? "#{Config.public_directory}/#{&1}"))
  end
end
