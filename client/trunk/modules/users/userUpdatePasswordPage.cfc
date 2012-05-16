<cfcomponent name="Users" extends="resources.page">
	
	<cffunction name="preObjectLoad">
		<cfset var uo = requestObject.getUserObject()>

		<cfif NOT uo.isloggedin()>
			<cfset uo.setFlash("Your session has expired, please log in.")>
			<cflocation url="/user/login/" addtoken="false">
		</cfif>
	</cffunction>
	
    <cffunction name="postObjectLoad">
		<cfset var form = "">
		<cfset var formitem = "">
		
		<!--- contentarea1 --->
		<cfset addObjectByModulePath('middleItem_2_Content', 'users', '', structnew(), 'updatePasswordform')>

	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>