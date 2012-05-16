<cfcomponent name="moduleMgr" extends="resources.page">
		
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		<cfset var moduleaction = "default">
		<!--- main title --->
		<cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('mainTitle', 'simpleContent', data)>
	
		<!--- mainContent --->
		<cfset data.path = requestObject.getFormUrlVar("path")>
		<cfset data.pathlen = listlen(data.path, "/")>

		<cfif data.pathlen GT 2>
			<cfset moduleAction = listgetat(data.path, 3, "/")>
		</cfif>
		
		<cfset addObjectByModulePath('contents', 'modulemanager', data, moduleAction)>
		<!---><cfset variables.pageObjects['mainContent'].Obj = createObject('component','modules..controller').init(variables.pageinfo.title)>--->
	</cffunction>
</cfcomponent>