<cfcomponent name="HTMLContent" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="SaveContent">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getEditableModel(requestObject, userobj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset var objString = CreateObject('component', 'utilities.string').init()>
		
		<cfset requestvars.content = replace(requestvars.content, 'class="MsoNormal"', "","all")>
		<cfset requestvars.content = replace(requestvars.content, 'align="center"', 'style="text-align:center;"',"all")>
		
		<cfset requestvars.content = objString.htmlentities
				(
					objString.parseHtml
					(
						strHtml = requestvars.content,
						asXhtml = true
					)
				)>
	
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