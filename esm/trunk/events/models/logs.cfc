<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"Events",
			"tableName":"events",
			"events":{
				"save events":{"message":"{savemode} event &quot;{name}&quot;."},
				"delete events":{"message":"deleted event &quot;{name}&quot;."},
				"downloaded attendees":{"message":"Downloaded attendees for event &quot;{eventname}&quot;."}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>