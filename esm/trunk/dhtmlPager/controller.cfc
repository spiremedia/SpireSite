<cfcomponent name="dhtmlpager" extends="resources.abstractControllerWEditables">
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
 
        <cfset displayObject.setData('itemsjson', getUtility('json').encode(editablemodel.getinfo().items))>
		<cfset displayObject.setWidgetOpen('mainContent','1,2')>
	</cffunction>
		
</cfcomponent>