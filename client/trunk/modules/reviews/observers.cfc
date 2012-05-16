<cfcomponent name="ordersobservers">
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="page_objects">
		<cfargument name="observed" required="true">
		<cfset var path = requestObject.getFormUrlVar("path")>
		<cfset var data = structnew()>
		
		<cfif requestObject.getFormUrlVar("path") EQ "user/">
			<cfset observed.addObjectByModulePath('middleItem_4_Content', 'reviews', '', structnew(), 'myreviews')>
		</cfif>
		
		<cfif refindnocase('^(wine|spirits|beer|cordials\-liqueurs)\/product\/', requestObject.getFormUrlVar("path"))>
			<cfset observed.addObjectByModulePath('middleItem_4_Content', 'reviews', '', data, 'reviews')>
		</cfif>

		<cfreturn observed>
	</cffunction>
	
</cfcomponent>