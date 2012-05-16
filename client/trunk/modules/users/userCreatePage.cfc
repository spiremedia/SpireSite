<cfcomponent name="Users" extends="resources.page">
	
    <cffunction name="postObjectLoad">
		<cfset var form = "">
		<cfset var formitem = "">
		
		<!--- login form --->
		<cfset addObjectByModulePath('leftItem_2_Content', 'users', '', structnew(), 'loginform')>
		
		<!--- create user form --->
		<cfset addObjectByModulePath('middleItem_2_Content', 'users', '', structnew(), 'createform')>

	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>