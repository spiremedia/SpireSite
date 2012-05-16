<cfcomponent name="messaging" extends="resources.abstractController">

	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var mdl = getmessagingmodel(requestObject, userObj)>
				
		<cfset displayObject.setData('browse', mdl.getAll())>
	</cffunction>

	<cffunction name="getmessagingModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "messaging.models.messaging").init(arguments.requestObj, arguments.userObj)>
		<cfset m.attachObserver(createObject("component", "messaging.models.logs").init(arguments.requestObj, arguments.userObj))>)>
		<cfreturn m>
	</cffunction>
	
	<cffunction name="getlogModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfreturn createObject("component", "messaging.models.logs").init(arguments.requestObj, arguments.userObj)>
	</cffunction>
	
	<cffunction name="addMessaging">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var mdl = getmessagingmodel(requestObject, userObj)>
		<cfset var logs = getLogModel(requestObject, userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('browse', mdl.getAll())>
			
		<cfif requestObject.isformurlvarset('id')>
			<cfset mdl.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('Messaging', mdl)>
		<cfelse>
			<cfset mdl.Load(0)>
			<cfset displayObject.setData('Messaging', mdl)>
		</cfif>

		<cfif requestObject.isformurlvarset('sortdir')>
			<cfset displayObject.setWidgetOpen('mainContent','2')>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>
	
	</cffunction>
	<cffunction name="editMessaging">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addMessaging(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	<cffunction name="DeleteMessaging">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getMessagingmodel(requestObject, userObj)>
		
		<!---<cfset mdl.load(requestObject.getformurlvar('id'))>--->
				
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete news">
		</cfif>

		<cfif mdl.delete(requestObject.getformurlvar('id'))>
			<!---<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
			<cfif lcl.filename NEQ "">
				<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
				<cfset lcl.siteinfo = application.sites.getSite(arguments.userObj.getCurrentSiteId())>
				<cfset fs.delete(lcl.siteinfo.machineRoot & 'docs/news/' & lcl.filename)>
			</cfif>--->
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Messaging Item has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/messaging/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Messaging Item Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	<cffunction name="SaveMessaging">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getMessagingmodel(requestObject, userobj)>
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset mdl.setValues(requestVars)>
			
		<cfif mdl.save()>
			<cfset lcl.id = mdl.getId()>
			<cfset lcl.msg = structnew()>
            
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "Updated Messaging Item">
            <cfelse>
            	<cfset lcl.msg.message = "Saved Messaging Item">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
            
			<cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "/messaging/Browse/?id=#lcl.id#">
            <cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var mdl = getMessagingmodel(requestObject, userObj)>
		<cfset var srch = structnew()>
		<cfset displayObject.setData('browse', mdl.getAll())>
		
		<cfset srch.name = arguments.requestObject.getFormUrlVar('searchkeyword')>
		<cfset displayObject.setData('searchResults', mdl.like(srch))>
	</cffunction>
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var mdl = getMessagingmodel(requestObject, userObj)>
		
		<cfset displayObject.setData('browse', mdl.getAll())>
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
</cfcomponent>
