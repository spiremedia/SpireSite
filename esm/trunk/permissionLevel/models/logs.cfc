<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"PermissionLevel",
			"tableName":"PermissionLevels",
			"events":{
				"insert permissionLevel":{"message":"Inserted permission level &quot;{name}&quot;."},
				"update permissionLevel":{"message":"Updated permission level &quot;{name}&quot;."},
				"delete permissionLevels":{"message":"Deleted permission level &quot;{name}&quot;."}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>