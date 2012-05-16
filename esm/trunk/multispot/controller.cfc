<cfcomponent name="multispot" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = "">
		
		<cfif NOT requestObject.isformurlvarset('id')>
				Please go back and select a content area to edit first please.<cfabort>
		</cfif>
		
		<cfset model = createObject('component', 'multispot.models.editable').init(requestObject, userobj)>
		
		<cfset displayObject.setData('mdl', model)>
		
	</cffunction>
	
</cfcomponent>