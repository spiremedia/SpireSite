<cfcomponent name="activityLogs" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startorm("activityLogs")>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>