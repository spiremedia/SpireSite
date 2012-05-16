<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"News",
			"tableName":"NewsItems",
			"events":{
				"save newsitems":{"message":"{savemode} news item &quot;{name}&quot;."},
				"destroy newsitems":{"message":"Delete news item &quot;{name}&quot;."},
				"save newstypes":{"message":"{savemode} news type &quot;{name}&quot;.","tablename":"newsTypes"},
				"delete newstypes":{"message":"Delete news type &quot;{name}&quot;.","tablename":"newsTypes"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>