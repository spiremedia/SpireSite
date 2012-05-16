<cfcomponent name="ajobservers">
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="page_objects">
		<cfargument name="observed" required="true">
		<cfset var path = requestObject.getFormUrlVar("path")>
	
		<cfif left(path, 4) EQ "user" AND path NEQ "user/login/" AND path NEQ "user/create/">
			<cfset observed.addObjectByModulePath('leftItem_2_Content', 'users', '', structnew(), 'userMenu')>
		</cfif>
		
		<cfreturn observed>
	</cffunction>
	
</cfcomponent>