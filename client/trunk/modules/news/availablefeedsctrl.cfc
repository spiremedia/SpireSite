<cfcomponent name="rssnewslistcontroller" output="false" extends="resources.abstractSubController">
		
	<cffunction name="showHTML" output="false">
		<cfset var html = "">
		<cfset variables.rssfeedlist = newsmodel.getRssFeeds()>
		<cfsavecontent variable="html">
			<div class="feedListing">
				<cfoutput>
				<cfif variables.rssfeedlist.recordcount>
					<cfloop query="variables.rssfeedlist">
						<a class="rsslink" href="#requestObject.getVar("siteurl")#rss/news/#id#/">#title#</a>
						<div>#description#</div>
					</cfloop>
				<cfelse>
					<p>There are currently no rss feeds available.</p>
				</cfif>
                </cfoutput>
			</div>
		</cfsavecontent>
		<cfset html = parseforlanguage(html)>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.data#>
		<cfabort>
	</cffunction>
</cfcomponent>