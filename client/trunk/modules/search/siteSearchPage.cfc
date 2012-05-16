<cfcomponent name="siteSearrchPage" extends="resources.page">
	<cffunction name="preobjectLoad">
		<cfset variables.newsid = variables.requestObject.getFormUrlVar('path')>
		<cfset variables.newsid = listlast(variables.newsid, "/")>

		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|Search~NULL~/search/|results|">
		<cfset variables.pageInfo.title = "Search">
		<cfset variables.pageInfo.pagename = "Search">
		<cfset variables.pageInfo.description = "">
		<cfset variables.pageInfo.keywords = "">
		<cfset variables.pageInfo.template = "interior2column">
	</cffunction>
    
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>

		<!--- left col --->
		<cfset data = structnew()>
		<cfset addObjectByModulePath('leftItem_1_Content', 'Search', "", data, "searchform")>
		
		<!--- results --->	
		<cfset addObjectByModulePath('middleItem_2_Content', 'Search', "", data, "default")>
	</cffunction>
</cfcomponent>