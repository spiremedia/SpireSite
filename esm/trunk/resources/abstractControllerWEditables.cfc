<cfcomponent name="parent controller" extends="resources.abstractController">
		
	<cffunction name="getEditableModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var mdl = createObject('component','#requestObject.getModuleFromPath()#.models.editable').init(requestObject, userObj)>
		<cfreturn mdl>
	</cffunction>
		
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editModel = getEditableModel(requestObject, userobj)>
	
		<cfif isdefined("variables.get#requestObject.getModuleFromPath()#model")>

			<cfinvoke component="#this#" method="get#requestObject.getModuleFromPath()#model" returnvariable="itemmodel">
				<cfinvokeargument name="requestObj" value="#requestObject#">
				<cfinvokeargument name="userObj" value="#userObj#">
			</cfinvoke>
			
			<cfset displayObject.setData('#requestObject.getModuleFromPath()#Model', itemmodel)>
		</cfif>
		
		<cfset displayObject.setData('editModel', editModel)>
		
	</cffunction>

	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editModel = getEditableModel(requestObject, userobj)>
		<cfset var lcl = structnew()>
		
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<!--- 
			setting the where selects the 
			staged object to be updated in the update 
		--->
		
		<cfset requestvars.where = structnew()>
        <cfset requestvars.where['status'] = 'staged'>

		<cfset editModel.setValues(requestVars)>

		<cfif editModel.save()>
			<cfset lcl.reloadBase = 1>
			<cfset displayObject.sendJson( lcl )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = editModel.GetValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="deleteClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editModel = getEditableModel(requestObject, userobj)>
	
		<cfset editModel.delete(requestObject.getFormUrlVar('id'))>
	
		<cfset lcl.reloadBase = 1>
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
	
</cfcomponent>