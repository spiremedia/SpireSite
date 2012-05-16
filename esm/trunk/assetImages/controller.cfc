<cfcomponent name="News" extends="resources.abstractControllerWEditables">
	
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

		<cfset var editablesModel = getEditableModel(arguments.requestObject, arguments.userObj)>
		<cfset var assetsModel = createObject("component", "assets.models.assets").init(arguments.requestObject, arguments.userObj)>
	
		<cfset displayObject.setData('editablesmodel', editablesModel)>

		<cfset displayObject.setData('images', assetsModel.getAllAvailableImages())>
	</cffunction>
	
	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'assetImages.models.editable').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		<cfset var requestvars = requestobject.getallformurlvars()>

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