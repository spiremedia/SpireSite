<cfcomponent name="PermissionLevel controller" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPermissionLevelModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','permissionlevel.models.permissionlevels').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','permissionlevel.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>	
	
	<cffunction name="getPermissionLevelItemsModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','permissionlevel.models.permissionlevelItems').init(arguments.requestObject, arguments.userObj)>
		<cfreturn mdl/>
	</cffunction>	
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','permissionlevel.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getLogObj(requestObject, userobj)>

		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('recentActivity', logs.getRecentModuleHistory(requestObject.getModuleFromPath()))>
	</cffunction>
	
	<cffunction name="addPermissionLevel">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
		<cfset var itemsmodel = getPermissionLevelItemsModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var l = structnew()>
						
		<cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>
		
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('availableUsers', dispatcher.callExternalModuleMethod('users','getAvailableUsers', requestObject, userobj) )>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('item', model)>
			<cfset displayObject.setData('saveditems', itemsmodel.getPermissions(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
		<cfelse>
			<cfset model.load(0)>
			<cfset displayObject.setData('item', model)>	
			<cfset displayObject.setData('saveditems', itemsmodel.getPermissions(0))>
		</cfif>
		
		<cfset displayObject.setWidgetOpen('mainContent','1,2')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

	</cffunction>
	
	<cffunction name="editPermissionLevel">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addPermissionLevel(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="SavePermissionLevel">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfif (requestvars.id EQ "" AND NOT userObj.isAllowed("PermissionLevel", "Add Permission Level"))
				OR (requestvars.id NEQ "" AND NOT userObj.isAllowed("PermissionLevel", "Edit Permission Level"))>
			<cfset lcl.message = "You do not have permission to save this item">
			<cfset displayObject.sendJson( lcl )>
		</cfif>
		
		<cfset model.setValues(requestVars)>
		<cfset model.setSecurityItemsFromXml(dispatcher.getSecurityItems())>
	
		<cfif model.savePL()>
			<cfset lcl.msg = structnew()>	
			<cfif requestObject.getFormUrlVar('id') EQ "">
				<cfset lcl.msg.message = "Permission Level Added">
				<cfset lcl.msg.switchtoedit = model.getId()>
			<cfelse>
				<cfset lcl.msg.message = "Permission Level Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/permissionLevel/Browse/?id=#model.getId()#">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.clearvalidation = 1>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeletePermissionLevel">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletesecuritygroup">
		</cfif>

		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/permissionLevel/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.html = "<div id=""msg"">The  Permission Level has been deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
							
		<cfset displayObject.setData('list', model.getAll())>
		
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', arguments.userobj)>

	</cffunction>
	
	<cffunction name="GetUserRights">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset  model = getPermissionLevelModel(arguments.requestObject, arguments.userObj)>
		
		<cfreturn model.getUserRights(requestObject.getVar('userid'))>
	</cffunction>
</cfcomponent>