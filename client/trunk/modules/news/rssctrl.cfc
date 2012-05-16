<cfcomponent name="rssnewslistcontroller" output="false" extends="resources.abstractSubController">
		
	<cffunction name="showHTML" output="false">
		<cfset var columnmap = structnew()>
        <cfset var meta = structnew()>
        <cfset var rss = "">
        <cfset var urlpathnodash = rereplace(requestObject.getVar("siteurl"), "\/$", "")>
		
		<cfset variables.id = listlast(requestObject.getFormUrlVar("path"), "/")>
		<cfset variables.rssfeeditem = newsmodel.getFeedInfo(variables.id)>
        <cfset variables.rssfeedlist = newsmodel.getAvailableNewsItems(variables.id)>model

		<cfoutput>
		<cfsavecontent variable="rss"><?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
<channel>
<title>#xmlformat(variables.rssfeeditem.title)#</title>
<link>#xmlformat("#requestObject.getVar("siteurl")#rss/#variables.rssfeeditem.id#/")#</link>
<description><![CDATA[ #variables.rssfeeditem.description# ]]></description>
<lastBuildDate></lastBuildDate>
<language>en-us</language>
<cfloop query="variables.rssfeedlist">
<cfif variables.rssfeedlist.linkpageid NEQ "">
	<cfset link = xmlformat("#urlpathnodash#{{link[#variables.requestObject.getVar("siteid")#][#variables.rssfeedlist.linkpageid#]}}")>
<cfelse>
	<cfset link = xmlformat("#urlpathnodash#/NewsAndEvents/News/#variables.rssfeedlist.id#/")>
</cfif>
<item>
<title>#xmlformat(variables.rssfeedlist.title)#</title>
<link>#link#</link>
<pubDate>#dateformat(itemdate, "ddd, dd mmm yyyy")# #timeformat(itemdate, "HH:mm:ss")#</pubDate>
<description><![CDATA[ #variables.rssfeedlist.description# ]]></description>
	<guid isPermaLink="true">#link#</guid>
</item>
</cfloop>
</channel>
</rss></cfsavecontent>
		</cfoutput>
       <!--- <!--- Map the orders column names to the feed query column names. --->

        <cfset columnMap.publisheddate = "MODIFIED"> 
        <cfset columnMap.content = "DESCRIPTION"> 
        <cfset columnMap.title = "TITLE"> 
        <cfset columnMap.rsslink = "ID">
        
        <!--- Set the feed metadata. --->
        <cfset meta.title = variables.rssfeeditem.title>
        <cfset meta.link = requestObject.getVar("siteurl") & 'rss/#variables.rssfeeditem.id#/'>
        <cfset meta.description = variables.rssfeeditem.description> 
        <cfset meta.version = "rss_2.0">
        
        <!--- Create the feed. --->
        <cffeed action="create" 
            query="#variables.rssfeedlist#" 
            properties="#meta#"
            columnMap="#columnMap#" 
            xmlvar="rss">
--->
		<cfset rss = this.parseforlanguage(rss)>
		<cfreturn rss>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.data#>
		<cfabort>
	</cffunction>
</cfcomponent>