<cfcomponent name="Events" extends="resources.abstractModel">
`	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>

		<cfreturn this>	
	</cffunction>
	
	<cffunction name="getPageObjects">
		<cfargument name="id" required="true">
		<cfargument name="mode" required="true">
		<cfset lcl = structnew()>
		<cfquery name="lcl.q" datasource="#requestObject.getVar("dsn")#">
			SELECT * 
			FROM pageObjects_view 
			WHERE status = <cfqueryparam value="#arguments.mode#" cfsqltype="cf_sql_varchar">
				AND pageid = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#requestObject.getVar("siteid")#" cfsqltype="cf_sql_varchar">
				AND deleted = 0
		</cfquery>
		<cfreturn lcl.q>
	</cffunction>

</cfcomponent>