<cfcomponent name="news View" extends="resources.page">
   
	<cffunction name="postObjectLoad">
		<!--- mainContent --->
		<cfset addObjectByModulePath('onecontent', 'news', "", structnew(), "rss")>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>