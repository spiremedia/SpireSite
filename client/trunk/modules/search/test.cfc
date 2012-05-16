<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">

	<cffunction name="setUp" returntype="void" access="public">		
		<cfset var lcl = structNew()>

		<cfset variables.unittestname = "Unit Test Page">
		<cfset this.unittestsearchterm = "Unit Test Page">
		<cfset variables.criteria = "Unit Test">
		<cfset variables.pageid = createuuid()>
		<cfset variables.requestObject = request.requestObject>

		<!--- <cfset loadController(data = structnew())>
		<cfset variables.controller = variables.controller.index(module="search", moduleaction="index")>
		--->
		<!--- setup assets for indexing --->
		<cfset variables.assetsObj = createObject("component","modules.assets.test")>
		<cfset variables.assetsObj.setUp()>
		
		<!--- setup events for indexing --->
		<cfset variables.eventsObj = createObject("component","modules.events.test").init()>
		<cfset variables.eventsObj.setUp()>
		<!--- setup news for indexing --->
		<cfset variables.newsObj = createObject("component","modules.news.test").init()>
		<cfset variables.newsObj.setUp()>

		<!--- setup page for indexing --->
		<cfquery name="lcl.qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id FROM sitepages WHERE pageurl = 'Home'
		</cfquery>
		<cfset lcl.parentid = lcl.qry.id>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO sitepages (id,pagename,pageurl,title,status,sort,siteid,parentid,template,innavigation,subsite,searchindexable,summary)
			VALUES (
			<cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="UnitTesting" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="published" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
			<cfqueryparam value="#variables.requestObject.getVar('siteid')#:published" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#lcl.parentid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="Interior2Column" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
			<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
			<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
			<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>

	</cffunction>

	<cffunction name="teardown" returntype="void" access="public">
		<cfset var lcl = structnew()>

		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM sitepages WHERE
					id = <cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">
					OR pagename = <cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE  FROM siteSearches WHERE criteria = <cfqueryparam value="#variables.criteria#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM events WHERE title = <cfqueryparam value="unit test event" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM newsitems WHERE title = <cfqueryparam value="unit test news" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM assets WHERE name = <cfqueryparam value="unit test asset" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cftry>
		<cfset variables.assetsObj.teardown()>
		<cfset variables.eventsObj.teardown()>
		<cfset variables.newsObj.teardown()>
		<cfcatch></cfcatch>
		</cftry>

		<!---  reindex search - remove test results --->
		<cfsetting requesttimeout="50000">
		<cfset lcl.httpObj = createObject('component','utilities.http').init()>
		<cfset lcl.httpObj.setHost("http://#cgi.HTTP_HOST#")>
		<cfset lcl.httpObj.setPath("/system/refreshSearch/")>		
		<cfset lcl.httpObj.load()>
	</cffunction>

	<cffunction name="loadController" access="private">
		<cfargument name="data" default="#structnew()#">
		<cfargument name="requestObject" default="#variables.requestObject#">
		<cfargument name="pageref" default="#structnew()#">
		<cfset variables.controller = createObject("component","modules.search.controller").init(
			data=arguments.data,
			requestObject=arguments.requestObject,
			pageref=arguments.pageref,
			name = "default"
		)>
	</cffunction>	

	<cffunction name="testSearchControllers">
		<cfset var parameterlist = structnew()>
		<cfset var furl = structnew()>
		<cfset var lcl = structnew()>
		<cfset var html = "">

		<!--- test index controller --->
		<cfsetting requesttimeout="50000">
		<cfset lcl.httpObj = createObject('component','utilities.http').init()>
		<cfset lcl.httpObj.setHost("http://#cgi.HTTP_HOST#")>
		<cfset lcl.httpObj.setPath("/system/refreshSearch/")>		
		<cfset lcl.response = lcl.httpObj.load()>
		<cfset html = lcl.response.getHTML()>

		<cfset assertequals(expected=0,actual=refindnocase("Access Denied",html),message="Access denied for search indexing. Add Server IP to the securityIPs db table.")>
		<cfset asserttrue(condition = refindnocase("Pages indexed",html),message="did not index pages")>
		<cfset asserttrue(condition = refindnocase("Files indexed",html),message="did not index files")>

		<cfset asserttrue(condition = refindnocase(variables.assetsObj.unittestsearchterm,html),message="did not find asset #variables.assetsObj.unittestsearchterm# in search indexed items")>
		<cfset asserttrue(condition = refindnocase(variables.eventsObj.unittestsearchterm,html),message="did not find event #variables.eventsObj.unittestsearchterm# in search indexed items")>
		<cfset asserttrue(condition = refindnocase(variables.newsObj.unittestsearchterm,html),message="did not find news #variables.newsObj.unittestsearchterm# in search indexed items")>
		<cfset asserttrue(condition = refindnocase(this.unittestsearchterm,html),message="did not find page with #this.unittestsearchterm# in search indexed items")>

		<!--- test search controller --->
		<cfset parameterlist.editable = 1> 
		<cfset loadController(parameterlist = parameterlist)>
		<cfset variables.controller = variables.controller.default(module="search", moduleaction="default")>
		<cfset html = variables.controller.showHTML(module="search", moduleaction="default")>
		<cfset asserttrue(condition = refind('search box',html),message="did not find text for esm content area search widget")>
		<cfset parameterlist.editable = 1> 
		<cfset furl.criteria = variables.criteria>
		<cfset furl.page = 1>
		<cfset lcl.decRequestObject = createobject('component', 'resources.altformurlRequestDecorator').init(requestObject)>
		<cfset lcl.decRequestObject.setRequestFields(furl)> 
		<cfset loadController(data=structnew(), requestObject=lcl.decRequestObject, pareref = structnew())>
		<cfset variables.controller = variables.controller.default(module="search", moduleaction="default")>
		<cfset html = variables.controller.showHTML(module="search", moduleaction="default")>
		<cfset asserttrue(condition = refind('<div class="srchResult">.*</div>',html),message="did not find matching div elements")>
		<cfset asserttrue(condition = refindnocase(variables.criteria,html),message="did not find text for search results")>

		<cfset asserttrue(condition = refindnocase(variables.assetsObj.unittestsearchterm,html),message="did not find asset #variables.assetsObj.unittestsearchterm# in search results")>
		<cfset asserttrue(condition = refindnocase(variables.eventsObj.unittestsearchterm,html),message="did not find event #variables.eventsObj.unittestsearchterm# in search results")>
		<cfset asserttrue(condition = refindnocase(variables.newsObj.unittestsearchterm,html),message="did not find news #variables.newsObj.unittestsearchterm# in search results")>

		<cfset asserttrue(condition = refindnocase(this.unittestsearchterm,html),message="did not find term #this.unittestsearchterm# in search results")>

	</cffunction> 
</cfcomponent>