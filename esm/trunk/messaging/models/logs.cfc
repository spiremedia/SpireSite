<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"messaging",
			"tableName":"messaging",
			"events":{
				"save messaging":{"message":"{savemode} Message &quot;{name}&quot;."},
				"destroy messaging":{"message":"Delete Message &quot;{name}&quot;."},
				"delete messaging":{"message":"Delete Message &quot;{name}&quot;.","tablename":"newsTypes"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>