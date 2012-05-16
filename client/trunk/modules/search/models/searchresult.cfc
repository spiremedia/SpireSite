<cfcomponent name="indexable" extends="resources.abstractmodel">
	
	<cffunction name="init">
    	<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startOrm("sitesearches")>
        <cfreturn this>
	</cffunction>
	
	<cffunction name="setSearchRs">
		<cfargument name="searchrs" required="true">
		<cfset variables.searchrs = arguments.searchrs>
	</cffunction>
	
	<cffunction name="getSearchRs">
		<cfreturn variables.searchrs>
	</cffunction>
		 	
	<cffunction name="setChopped">
		<cfargument name="chopped" required="true">
		<cfset variables.chopped = arguments.chopped>
	</cffunction>
	
	<cffunction name="doChop">
		<cfreturn NOT variables.chopped>
	</cffunction>
		 			
</cfcomponent>