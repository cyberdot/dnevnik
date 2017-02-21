defmodule Dnevnik.DisqusComments do
	
	def render(document_url, disqus_url) do
		"""
			<div id="disqus_thread"></div>
			<script>
			    var disqus_config = function () {
					this.page.url = '#{document_url}';  
					this.page.identifier = '#{document_url}';
				};

			(function() { 
				var d = document, s = d.createElement('script');
				s.src = '//#{disqus_url}/embed.js';
				s.setAttribute('data-timestamp', +new Date());
				(d.head || d.body).appendChild(s);
			})();
			</script>
			<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
				
		"""
	end
end