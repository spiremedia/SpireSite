<cfcomponent name="search" output="false">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	<cffunction name="getSearchMonths">
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				DATEPART(yy,created) year,
				DATEPART(mm,created) month
			FROM siteSearches
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#">
			GROUP BY 	DATEPART(yy,created), DATEPART(mm,created)
			ORDER BY 	DATEPART(yy,created) desc, DATEPART(mm,created) desc
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="getSearchItemsByMonth">
		<cfargument name="month">
		<cfargument name="year">
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				criteria, recordsfound, created
			FROM siteSearches
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#">
				AND DATEPART(mm,created) = <cfqueryparam value="#month#" cfsqltype="cf_sql_varchar">
				AND DATEPART(yy,created) = <cfqueryparam value="#year#" cfsqltype="cf_sql_varchar">
			ORDER BY created
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="keywordSearch">
		<cfargument name="word">
		
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT criteria, recordsfound, created
			FROM siteSearches
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND criteria = <cfqueryparam value="#arguments.word#" cfsqltype="cf_sql_varchar">
			ORDER BY created desc
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="findIndexables">
		<cfargument name="word">
		
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT id, objid,title,description, LEN(error) hasError,reindex,created,lastindexed
			FROM indexables
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND (
					objid like <cfqueryparam value="%#arguments.word#%" cfsqltype="cf_sql_varchar">
					OR title like <cfqueryparam value="%#arguments.word#%" cfsqltype="cf_sql_varchar">
					OR description like  <cfqueryparam value="%#arguments.word#%" cfsqltype="cf_sql_varchar">
				)
			ORDER BY created desc
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="getIndexable">
		<cfargument name="id">
		
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT *
			FROM indexables
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn r>
	</cffunction>
</cfcomponent>