<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset var lcl = structNew()>
		
		<cfset variables.unittestname = "Unit Test News">
		<cfset this.unittestsearchterm = "Unit Test News">
		<cfset variables.newsTypeid = createuuid()>
		<cfset variables.newsItemid = createuuid()>
		<cfset variables.newsItemToNewstypeid = createuuid()>
		<cfset variables.requestObject = request.requestObject>
		<cfset variables.title = "This is a title.">
    	<!--- <cfset loadController()> --->
		
		<cfquery name="lcl.qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id FROM users
			WHERE username = 'sa@spiremedia.com'
		</cfquery>
		
		<cfset lcl.userid = lcl.qry.id>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO newsTypes ( id,name,siteid)
			VALUES (
				<cfqueryparam value="#variables.newsTypeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="Unit Test News" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO newsItems ( id,name,title,description,changedby,siteid,itemdate,startdate,enddate,onhomepage)
			VALUES (
				<cfqueryparam value="#variables.newsItemid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#lcl.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#CreateODBCdate(DateAdd('m', 1, Now()))#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			)			
		</cfquery>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO newsItemsToNewsTypes ( id,newsTypeid,newsItemid,siteid)
			VALUES (
				<cfqueryparam value="#variables.newsItemToNewstypeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.newsTypeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.newsItemid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
          
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM newsItemsToNewstypes WHERE id = <cfqueryparam value="#variables.newsItemToNewstypeid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM newsItems WHERE id = <cfqueryparam value="#variables.newsItemid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM newsTypes WHERE id = <cfqueryparam value="#variables.newsTypeid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="data" default="#structnew()#">
    	<cfargument name="requestObject" default="#variables.requestObject#">
    	<cfargument name="pageref" default="#structnew()#">
    	<cfset variables.controller = createObject("component","modules.news.controller").init(
			TITLE = variables.title,
			data=arguments.data,
			requestObject=arguments.requestObject,
			pageref=arguments.pageref,
			name = "default"
		)>
    </cffunction>
	
    <!--- model tests --->
    <cffunction name="testNewsOutofDate">
		<cfset var lcl = structNew()>
		<cfset var data = structnew()>
    	<cfset var itm = "">
        <cfset var count = "">
		
		
    	<cfset loadController(data = data)>
		<cfset itm = variables.controller.getNewsModel("news")>
		
        <cfquery datasource="#variables.requestObject.getVar('dsn')#" result="m">
			UPDATE newsItems SET startdate = <cfqueryparam value="#CreateODBCdate (dateadd("d",1, Now() ) )#" cfsqltype="cf_sql_date">
            WHERE id = <cfqueryparam value="#variables.newsItemid#" cfsqltype="cf_sql_varchar">
		</cfquery>
        
		<cfset count = itm.getAvailableNewsItems( newstype = variables.newsTypeid )>

        <cfset assertequals(expected=0,actual=count.recordcount,message="should not have found news item out of date")>
    </cffunction>
    
    <cffunction name="testGettingNews">
		<cfset var lcl = structNew()>
    	<cfset var itm = "">
        <cfset var count = "">
		
		<cfset loadcontroller(lcl)>
		<cfset itm = variables.controller.getNewsModel("news")>
		
		<cfset count = itm.getAvailableNewsItems( newstype = variables.newsTypeid ).recordcount>
        <cfset assertequals(expected=1,actual=count,message="did not find available news type item")>
		
		<cfset count = itm.getNews(id = variables.newsItemid).recordcount>
        <cfset assertequals(expected=1,actual=count,message="did not find news item")>
		
		<cfset count = itm.getAllAvailableNewsItems().recordcount>
        <cfset assertNotEquals(expected=0,actual=count,message="did not find any news available")>		
    </cffunction>
    
    <!--- ctrlr tests --->
    <cffunction name="testShowHTML">
        <cfset var data = structnew()>
		<cfset var furl = structnew()>
		<cfset var itm = "">
    	
		<!--- news listing --->	
		<cfset data.itemid = variables.newsTypeid>
		<cfset data.pageing = 100>
    	<cfset loadController(data = data)>
		<cfset variables.controller = variables.controller.type(module="news", moduleaction="type")>
		<cfset html = variables.controller.showHTML(module="news", moduleaction="type")>

        <cfset asserttrue(condition = refind('<div class="newsList">.*</div>',html),message="did not find matching div elements")>
        <!---<cfset asserttrue(condition = refind('<div class="newsCrumbs">.*</div>',html),message="did not find news crumbs")>--->
        <cfset asserttrue(condition = refind('.*#variables.unittestname#.*',html),message="did not find #variables.unittestname# listing")>
		
		<!--- news item --->
		<cfset data.view = "newsdetail">
		<cfset itm = variables.controller.getNewsModel("news")>
		<cfset data.newsInfo = itm.getNews(id = variables.newsItemid)>
		
		<cfset data.itemid = variables.newsTypeid>
		<cfset data.pageing = 10>
    	<cfset loadController(data = data)>
		<cfset variables.controller = variables.controller.item(module="news", moduleaction="newsdetail")>
		
		<cfset html = variables.controller.showHTML(module="news", moduleaction="newsdetail")>

        <cfset asserttrue(condition = refind('<div class="newsDetail">.*</div>',html),message="did not find matching div elements")>
       <!---  <cfset asserttrue(condition = refind(variables.unittestname,html),message="did not find #variables.unittestname# html")> --->
    </cffunction>
	
    
    <cffunction name="testGetPagesforSiteSearch">
        <cfset var data = structnew()>
        <cfset var html = "">
        <cfset var aggregator = createobject('component','modules.search.searchableaggregator').init(requestObject=variables.requestObject)>
		
		<cftry>
			<cfset loadController(data = data)>
		
        	<cfset variables.controller.getPagesforSiteSearch( aggregator = aggregator)>
            <cfcatch>
            	<cfset fail("news search indexing fails : #cfcatch.message#")>
            </cfcatch>
        </cftry>
    </cffunction>
   
</cfcomponent>