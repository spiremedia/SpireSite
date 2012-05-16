<cfcomponent name="loginformctrl">

	<cffunction name="init">
		<cfargument name="data" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="pageRef" required="true">
		<cfargument name="name" required="true">
		<cfargument name="module" required="true">
		<cfargument name="moduleaction" required="true">
		
		<cfset var lf = createObject("component", "modules.users.forms.loginform").init(requestObject)>
		<cfset lf.setTitle("Existing Users")>
		<cfreturn lf>
	</cffunction>

</cfcomponent>