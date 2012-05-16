<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"Login",
			"tableName":"users",
			"events":{
				"user logged in":{"message":"Logged in from ip &quot;{ip}&quot;."},
				"save announcements":{"message":"{savemode} announcement &quot;{name}&quot;.","tableName":"announcements"},
				"destroy announcements":{"message":"deleted announcement &quot;{name}&quot;.","tableName":"announcements"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>