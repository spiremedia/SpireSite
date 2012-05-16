<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"Help",
			"tableName":"filesystem",
			"events":{
				"inserted help item":{"message":"Inserted &quot;{module}&quot; help doc.","nositeid":"true"},
				"updated help item":{"message":"Updated &quot;{module}&quot; help doc.","nositeid":"true"},
				"viewed help item":{"message":"Viewed &quot;{module}&quot; help doc.","nositeid":"true"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>