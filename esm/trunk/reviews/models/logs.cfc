<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset var tableName = "reviews">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfif requestObject.isformurlvarset('reviewsmodulename')>
			<cfset tableName = requestObject.getformurlvar('reviewsmodulename')>
		</cfif>
		
		<cfset setLogInfo('{
			"moduleName":"reviews",
			"tableName":"#tableName#",
			"events":{
				"save reviews":{"message":"Saved #tableName# review for &quot;{itemname}&quot;."},
				"delete reviews":{"message":"Deleted #tableName# review for &quot;{itemname}&quot;."}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>