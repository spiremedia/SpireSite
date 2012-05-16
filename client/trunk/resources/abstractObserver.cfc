<cfcomponent name="abstractobserver">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>
</cfcomponent>