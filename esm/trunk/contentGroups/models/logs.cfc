<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"ContentGroups",
			"tableName":"contentGroups",
			"events":{
				"insert contentGroup":{"message":"Inserted content group &quot;{name}&quot;."},
				"update contentGroup":{"message":"Updated content group &quot;{name}&quot;."},
				"delete contentgroup":{"message":"Deleted content group &quot;{name}&quot;."}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>