<cfcomponent name="Users" extends="resources.page">
	
    <cffunction name="postObjectLoad">
		<cfset var form = "">
		<cfset var formitem = "">
		
		<!--- contentarea1 --->
		<cfset addObjectByModulePath('leftItem_2_Content', 'users', '', structnew(), 'loginform')>

	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>