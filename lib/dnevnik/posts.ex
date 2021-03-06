defmodule Dnevnik.Posts do
    alias Dnevnik.{Config}
	
	@spec sort_by_date(posts :: [binary]) :: [binary]
	def sort_by_date(posts), do: posts |> Enum.sort(get_sort_function())
	
	@spec get_sort_function() :: :ascending | :descending	
	defp get_sort_function do
		case Config.data[:sort_posts] do
			"descending" -> sort_by_created :descending		
			"ascending" -> sort_by_created :ascending
			_ -> sort_by_created :ascending
		end
    end 
	
	@spec sort_by_created(sort :: atom) :: (atom -> boolean)
	defp sort_by_created(:ascending), do: &(DateTime.to_unix(&1.date_created) <= DateTime.to_unix(&2.date_created))  
	defp sort_by_created(:descending), do: &(DateTime.to_unix(&1.date_created) >= DateTime.to_unix(&2.date_created)) 	
  
end