<cfcomponent name="Navigation" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editablemodel = getEditableModel(arguments.requestObject, arguments.userObj)>
	
		<cfset displayObject.setData('editablemodel', editablemodel)>
	</cffunction>
	

	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'news.models.editable').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfparam name="requestvars.warchives" default="0">

        <cfif find("|", requestvars.moduleaction)>
			<cfset requestvars.itemid = gettoken(requestvars.moduleaction, 2, "|")>
        	<cfset requestvars.moduleaction = gettoken(requestvars.moduleaction, 1, "|")>
        <cfelse>
        	<cfset requestvars.itemid = "">
        </cfif>
		
		<cfset model.setValues(requestVars)>
	
		<cfif model.save()>
			<cfset lcl.reloadBase = 1>
			<cfset displayObject.sendJson( lcl )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>

</cfcomponent>