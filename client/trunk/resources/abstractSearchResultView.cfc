<cfcomponent name="abstractsearchresultview">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestobject>
		<cfset variables.data = structnew()>
		<cfreturn this>
	</cffunction>
	<cffunction name="setData">
		<cfargument name="data" required="true">
		<cfset variables.data = arguments.data>
	</cffunction>
</cfcomponent>