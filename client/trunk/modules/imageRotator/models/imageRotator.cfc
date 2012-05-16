<cfcomponent name="imageRotator Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getImages">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
			SELECT id, filename, relocate, name
			FROM homeimages
			WHERE active = 1 AND filename <> ''
				AND siteid = <cfqueryparam value="#variables.requestObject.getvar('siteid')#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn q>
	</cffunction>

</cfcomponent>
