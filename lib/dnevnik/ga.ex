defmodule Dnevnik.GoogleAnalytics do

	def render(account_id) do
		"""
			<!-- Google Analytics -->
			<script>
			window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
			ga('create', '#{account_id}', 'auto');
			ga('send', 'pageview');
			</script>
			<script async src='https://www.google-analytics.com/analytics.js'></script>
			<!-- End Google Analytics -->	
		
		"""
	end
end