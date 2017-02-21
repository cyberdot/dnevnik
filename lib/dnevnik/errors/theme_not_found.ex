defmodule Dnevnik.Errors.ThemeNotFound do
  defexception [:message]

  def exception({:local, theme}) do
    msg = "Theme '#{theme}' doesn't exist at './themes/#{theme}/'"
    %Dnevnik.Errors.ThemeNotFound{message: msg}
  end
end
