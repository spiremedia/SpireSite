<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"Assets",
			"tableName":"assets",
			"nositeid":true,
			"events":{
				"save assets":{"message":"{savemode} asset &quot;{name}&quot;."},
				"delete assets":{"message":"Delete asset &quot;{name}&quot;."},
				"save assetgroups":{"message":"{savemode} asset group &quot;{name}&quot;.","tablename":"assetGroups"},
				"delete assetgroups":{"message":"Delete asset group &quot;{name}&quot;.","tablename":"assetGroups"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>