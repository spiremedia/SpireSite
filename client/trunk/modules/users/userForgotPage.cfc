<cfcomponent name="Users" extends="resources.page">
	
    <cffunction name="postObjectLoad">
		<cfset var form = "">
		<cfset var formitem = "">
		
		<!--- contentarea1 --->
		<cfset addObjectByModulePath('middleItem_2_Content', 'users', '', structnew(), 'forgotform')>

	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>