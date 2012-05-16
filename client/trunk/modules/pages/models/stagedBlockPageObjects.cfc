<cfcomponent name="BlockPageObjects" extends="resources.abstractModel">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startOrm("stagedBlockPageObjects")>
		<cfreturn this>	
	</cffunction>
</cfcomponent>