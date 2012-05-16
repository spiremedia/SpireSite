<cfcomponent name="news" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startorm("newsItems")>
		<cfreturn this>
	</cffunction>

	<cffunction name="getAvailableNewsItemsByYear">
		<cfargument name="newsYear" required="no">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT n.id, n.title, n.itemdate, n.description, n.modified, n.linkpageid, n.assetid, datepart(yyyy,n.itemdate) as itemyear
			FROM newsItems n
			WHERE ((n.startdate IS NULL OR n.startdate < getDate())
				AND (n.enddate IS NULL OR n.enddate > getDate()))
				AND n.deleted = 0
				<cfif isDefined("arguments.newsYear") and arguments.newsYear neq "">
					AND datepart(yyyy,n.itemdate) = #arguments.newsYear#
				</cfif>
				ORDER BY itemyear DESC, itemdate DESC
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="getAvailableNewsItems">
    	<cfargument name="newstype" required="yes">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT distinct n.id, n.title, n.itemdate, n.description, n.modified, n.linkpageid, n.assetid
			FROM newsItems n
			INNER JOIN newsItemsToNewsTypes n2t ON n.id = n2t.newsItemId
			WHERE ((n.startdate IS NULL OR n.startdate < getDate())
				AND (n.enddate IS NULL OR n.enddate > getDate()))
				AND n2t.newsTypeId IN ( <cfqueryparam value="#arguments.newstype#" cfsqltype="CF_SQL_VARCHAR" list="yes">)
				AND n.deleted = 0
			ORDER BY itemdate DESC
		</cfquery>

		<cfreturn q>
	</cffunction>
    
    <cffunction name="getRssFeeds">
    	
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT id, title, description
            FROM newstypes
            WHERE hasrssfeed = 1
			AND deleted = 0
			ORDER BY title
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="getHomeNews">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT distinct n.id, n.title, n.itemdate, n.linkpageid, n.description
			FROM newsItems n
			INNER JOIN newsItemsToNewsTypes n2t ON n.id = n2t.newsItemId
			INNER JOIN newsTypes nt ON n2t.newsTypeId = nt.id
			WHERE ((n.startdate IS NULL OR n.startdate < getDate())
				AND (n.enddate IS NULL OR n.enddate > getDate()))
				<!--- AND nt.name = <cfqueryparam value="Home" cfsqltype="CF_SQL_VARCHAR"> --->
				AND n.deleted = 0
			ORDER BY itemdate DESC
		</cfquery>

		<cfreturn q>
	</cffunction>
    
    <cffunction name="getFeedInfo">
    	<cfargument name="id">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT id, title, description,hasrssfeed
            FROM newstypes
            WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND deleted = 0
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="getAllAvailableNewsItems">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT distinct n.id, n.title, n.itemdate, n.description
			FROM news_view n
			WHERE ((n.startdate IS NULL OR n.startdate < getDate())
				AND (n.enddate IS NULL OR n.enddate > getDate()))
			ORDER BY itemdate DESC
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="getNews">
		<cfargument name="id" required="true">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT e.[id] itemid, e.[name] itemname, e.[title] itemtitle, e.[description] itemdesc,e.[htmlText] itemhtml, e.[itemdate], e.[assetid], e.[linkpageid], 
				e.newstypesid ntid
			FROM news_view e
			WHERE e.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn me>
	</cffunction>

</cfcomponent>
