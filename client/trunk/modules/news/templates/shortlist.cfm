<h2><cfoutput>#variables.newsItem.title#</cfoutput></h2>
<div class="fixed">
	<cfoutput query="variables.newslist" maxrows="#variables.data.pageing#">
		<p>		
			<cfif variables.newslist.linkpageid NEQ "">
				<cfset lcl.link = "{{link[#variables.requestObject.getVar("siteid")#][#variables.newslist.linkpageid#]}}">
			<cfelse>
				<cfset lcl.link = "/NewsAndEvents/News/#id#/">
			</cfif>
			<a href="#lcl.link#">#dateformat(itemdate, "mm.dd.yy")#:</a>
			#title#
		</p>
	</cfoutput>
</div>
<p>
	<a class="right" href="/NewsAndEvents/" style="padding-right:25px;">View All News &raquo;</a>
	<a href="/NewsAndEvents/AvailableRSSFeeds/"><img class="valignMiddle" src="/ui/images/rss.png" alt="RSS" /></a>&nbsp;&nbsp;
	<a href="/NewsAndEvents/AvailableRSSFeeds/">RSS &raquo;</a>
</p>