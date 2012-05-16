<cfcomponent name="userflash" extends="resources.abstractsubcontroller">

	<cffunction name="init">
		<cfargument name="data" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="pageRef" required="true">
		<cfargument name="name" required="true">
		<cfargument name="module" required="true">
		<cfargument name="moduleaction" required="true">
		
		<cfset var userobj = requestObject.getUserObject()>
		
		<cfset variables.flash = userObj.getFlash()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfif len(variables.flash)>
			<cfreturn "<div class=""sitemessage"">#variables.flash#</div>">
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>

</cfcomponent>