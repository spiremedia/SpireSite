<cfcomponent name="Users" extends="resources.page">
	
    <cffunction name="preObjectLoad">
		<cfset var u = "">

		
		<cfset u = requestObject.getUserObject()>
		<cfset u.logout()>
		<cfset u.setFlash("User logged Out")>

	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>