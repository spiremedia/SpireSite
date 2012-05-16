<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"Pages",
			"tableName":"pageObjects]",
			"events":{
				"save pageObjects":{"message":"{savemode} &quot;{module}&quot; module in content spot &quot;{name}&quot; on page {urlpath}.", "alternateItemIdStr":"pageid"},
				"delete pageObjects":{"message":"Deleted &quot;{module}&quot; module from content spot &quot;{name}&quot; on page {urlpath}.", "alternateItemIdStr":"pageid"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="morereplaceables">
		<cfargument name="modelref">
		<cfargument name="more">
		<cfset var haha = "">
		<cfset var hoho = structnew()>
		<cfquery name="haha" datasource="#requestObject.getVar("dsn")#">
			SELECT urlpath FROM sitepages WHERE
			 sitepages.id = <cfqueryparam value="#modelref.getPageId()#" cfsqltype="cf_sql_varchar">
			 AND siteid = <cfqueryparam value="#modelref.getSiteId()#:staged" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset hoho.urlpath = "/" & haha.urlpath>
		<cfreturn hoho>
	</cffunction>
	
</cfcomponent>