<cfcomponent name="siteSearch" extends="resources.page">
	
	<cffunction name="preObjectLoad">
		<cfset var so = "">
		
		<cfset var data = structnew()>
		
		<!--- security --->
		<cfif isIPSafe(ip = CGI.REMOTE_ADDR) eq 0>
			Access Denied. You do not have sufficient privileges to view this page.
			<cfoutput>#cgi.REMOTE_ADDR#</cfoutput>
			<cfabort>
		</cfif>
		
		<cfsetting requesttimeout="50000">
		<cfset variables.pageinfo.template = "_blank">
	</cffunction>
	
	<cffunction name="postObjectLoad">
		<cfset var lcl = structnew()>
		<cfset lcl.path = requestObject.getFormUrlVar("path")>
		<cfset lcl.action = listlast(lcl.path,"/")>
		<cfif listfindnocase("indexsome,clear,synch,indexall,purge", lcl.action)>
			<cfset addObjectByModulePath('onecontent', 'search', "", structnew(), lcl.action)>
		</cfif>
	</cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>