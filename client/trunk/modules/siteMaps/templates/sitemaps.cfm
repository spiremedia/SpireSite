<div id="siteMapListing">
	<cfif NOT variables.sitemap.recordcount>
		There are no pages to display.
	<cfelse>
		<cfset lcl.sitemapTop = getSiteMapByLevel(level = 1)>		
		<ul>
			<cfoutput query="lcl.sitemapTop">
				<li><a href="#displayurlpath#" >#title#</a></li>
				#getSiteMapByParentId(parentid = id)#
			</cfoutput> 
		</ul>
	</cfif>
</div>

		