<cfcomponent name="Help" extends="resources.abstractController">
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getModel(requestObject, userobj)>
		<!---><cfset var logs = getLogModel(requestObject, userobj)>--->
		
		<cfset displayObject.setData('list', model.getHelpItems())>
		<!---><cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>--->
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','help.models.help').init(requestObject, userObj)>
		<cfset mdl.attachObserver(createObject('component',"help.models.log").init(requestObject, userObj))>
		<cfreturn mdl>
	</cffunction>
	<!--->
	<cffunction name="getLogModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','help.models.logs').init(requestObject, userObj)>
		<cfreturn mdl>
	</cffunction>
	--->
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getModel(arguments.requestObject, arguments.userobj)>
							
		<cfset displayObject.setData('list', model.getHelpItems())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>

	<!--- 	<cfset displayObject.setData('searchinfo', model.keywordsearch(requestObject.getformurlvar('searchkeyword')))> --->

		<cfreturn displayObject>
		
	</cffunction>

	<cffunction name="helpItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var evtinfo = structnew()>
		<cfset var model = getModel(requestObject,userobj)>
		<cfset model.load(requestObject.getFormUrlVar('m'))>
		<!---><cfset var logmodel = getLogModel(requestObject,userobj)>--->

		<cfset evtinfo.id = model.getField("module")>
		<cfset model.observeEvent('viewed help item', evtinfo)>

		<cfset displayObject.setData('list', model.getHelpItems())>
		<cfset displayObject.setData('userobj', arguments.userobj)>
		
		<cfset displayObject.setData('info', model)>
				
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('locationsearch', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="edithelpitem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getModel(requestObject,userobj)>
		<cfset model.load(requestObject.getFormUrlVar('m'))>
		<!---><cfset var logmodel = getLogModel(requestObject,userobj)>--->

		<cfset displayObject.setData('info', model)>
		<cfset displayObject.setData('list', model.getHelpItems())>

		<cfreturn displayObject>
		
	</cffunction>
		
	<cffunction name="SaveHelpItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getModel(requestObject, userobj)>
		
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfset model.setValue('contents', requestObject.getFormUrlVar('html'))>
		<cfset model.setValue('module', requestObject.getFormUrlVar('m'))>
			
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passvalidation()>
			<cfset model.save()>
			<cfset lcl.msg = structnew()>
			<cfset userobj.setFlash("Item Saved")>
			<cfset lcl.msg.relocate = "/Help/HelpItem/?m=#requestObject.getFormUrlVar('m')#">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>

	<cffunction name="DeleteHelpItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, userObj)>
		<cfset var vdtr = getUtility('DataValidator').init()>
	
		<cfset vdtr = model.validateDelete(vdtr, requestObject.getAllFormUrlVars())>
		
		<cfif NOT vdtr.passValidation()>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset model.deleteLocation(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>		
			<cfset lcl.msg.ajaxupdater = structnew()>
			<!---><cfset lcl.msg.ajaxupdater.url = "/Help/BrowseHelpItems/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>--->
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = 'rightContent'>
			<cfset lcl.msg.htmlupdater.html = '<div id="msg">The Help Item has been Deleted</div>'>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="BrowseHelpItems">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getModel(requestObject, userObj)>
	
		<cfset displayObject.setData('list', model.getHelpItems())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="createPdf">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getModel(requestObject, userObj)>
		<cfset var menu = displayObject.getMenuObject().getAllMainMenuItems()>

		<cfif left(server.coldfusion.productversion,1) EQ '7'>
			<cfinclude template="cf7createhelp.cfm">
		<cfelse>
			<cfinclude template="cf8createhelp.cfm">
		</cfif>
		
		<cfabort>
	</cffunction>
	
</cfcomponent>