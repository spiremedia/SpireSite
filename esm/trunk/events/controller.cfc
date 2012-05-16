<cfcomponent name="Events" extends="resources.abstractControllerWEditables">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var log = getLogObj(requestObject, userObj)>

		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('recentActivity', log.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

	</cffunction>
		
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','events.models.events').init(requestObject, userObj)>
		<cfset mdl.attachObserver(createObject('component','events.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','events.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="getAttendeeModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','events.models.eventattendees').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','events.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var lcl = structNew()>
		<cfset lcl.name = arguments.requestObject.getFormUrlVar('searchkeyword')>
		
		<cfset displayObject.setData('list', model.getAll())> 
		<cfset displayObject.setData('searchResults', model.like(lcl))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>

	</cffunction>

	<cffunction name="addEvent">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var attmodel = getAttendeeModel(argumentcollection = arguments)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var assetsData = dispatcher.callExternalModuleMethod('assets','getAvailableAssets', requestObject, userobj)>	
		<cfset var lcl = structnew()>
				
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>

		<cfloop query="assetsData">
			<cfset assetsData.name[currentRow] = assetsdata.assetgroups_name[currentrow] & ' - ' & assetsData.name[currentrow]>
		</cfloop>		
		<cfset displayObject.setData('assetsList', assetsData)>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('attendees', attmodel.getByEventid(requestObject.getformurlvar('id')))>
			<!--- <cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset lcl.id = requestObject.getformurlvar('id')>
			<cfset model.setValues(lcl)>
			<cfset displayObject.setData('eventid', requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('attendees', model.getAttendees(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('info', model)> --->
		<cfelse>
			<cfset model.Load(0)>
			<cfset displayObject.setData('info', model)>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', model.search(requestObject.getformurlvar('search')))>
		</cfif>
		
	</cffunction>
	
	<cffunction name="editEvent">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addEvent(displayObject,requestObject,userobj,dispatcher)>
	</cffunction>	
	
	<cffunction name="SaveEvent">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>		
		<cfset var model = getModel(requestObject, userobj)>				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfparam name="requestvars.onhomepage" default="0">
		<cfparam name="requestvars.showmaterialsform" default="0">
        <cfparam name="requestvars.showaddtlattendees" default="0">
		
		<cfset model.setValues(requestVars)>
		
		<cfif model.save()>
			<cfset lcl.msg = structnew()>	
			<cfif requestObject.getFormUrlVar('id') EQ "">
				<cfset lcl.msg.message = "The Event has been Added">
				<cfset lcl.msg.switchtoedit = model.getId()>
			<cfelse>
				<cfset lcl.msg.message = "The Event has been Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Events/Browse/?id=#model.getId()#">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.clearvalidation = 1>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<!--- <cfif vdtr.passvalidation()>			
			<cfset lcl.id = model.save()> 
			<cfset lcl.msg = structnew()>
			
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Event has been Saved.">
				<cfset lcl.msg.ajaxupdater = structnew()>
				<cfset lcl.msg.ajaxupdater.url = "/Events/Browse/?id=#lcl.id#">
				<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
				<cfset lcl.msg.clearvalidation = 1>
			<cfelse>
				<cfset userobj.setFlash("The Event has been Added.")>
				<cfset lcl.msg.relocate = "/Events/EditEvent/?id=#lcl.id#">
			</cfif>
			
			<cfset displayObject.sendJson( lcl.msg )> --->
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>		

	<cffunction name="DeleteEvent">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>		
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete event">
		</cfif>
		
		<cfset model.setValues(requestVars)>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.deleteEvent(requestObject.getformurlvar('id'))>
		</cfif>
		
		<cfset lcl.msg = structnew()>		
		<cfset lcl.msg.message = "The Event has been deleted">
		<cfset lcl.msg.ajaxupdater = structnew()>
		<cfset lcl.msg.ajaxupdater.url = "/Events/Browse/">
		<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
		<cfset lcl.msg.htmlupdater = structnew()>
		<cfset lcl.msg.htmlupdater.id = 'rightContent'>
		<cfset lcl.msg.htmlupdater.html = '<div id="msg">The Event has been Deleted</div>'>
		<cfset displayObject.sendJson( lcl.msg )>

	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getmodel(argumentcollection = arguments)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getAll())>
		
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="downloadXLS">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var attmodel = getAttendeeModel(argumentcollection = arguments)>
		<cfset var attlist= attmodel.getByEventId(requestObject.getformurlvar('id'))>
		<cfset var evtinfo = structnew()>
		
		<!--- <cfset var attlist= getModel(requestObject, userObj).getAttendees(requestObject.getformurlvar('id'))> --->

		<cfset evtinfo.id = requestObject.getformurlvar('id')>
		<cfset evtinfo.eventname = attlist.events_name>	

		<cfset attmodel.observeEvent('downloaded attendees', evtinfo)>
		
		<cfloop query="attlist">
			<cfset attlist.signupdatetime[currentrow] = '"' & dateformat(attlist.signupdatetime, "mm/dd/yyyy") & ' ' & timeformat(attlist.signupdatetime, "hh:mm tt") & '"'>
		</cfloop>

		<cfset displayObject.sendXLS(attlist)>
	</cffunction>
	
	<cffunction name="getAvailableEvents">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var model = getModel(requestObject, userobj)>
								
		<cfreturn model.getEvents()>
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editablemodel = getEditableModel(arguments.requestObject, arguments.userObj)>
		<cfset var eventsmodel = getModel(arguments.requestObject, arguments.userObj)>
		
		<cfset var s = structnew()>
		<cfset s["id"] = '"itemid":"#editablemodel.getItemId()#"'>
		<cfset s["ma"] = '"moduleaction":"list"'> 
		
		<cfset requestObject.setVar("itemsinpage", s)>
		
		<cfset displayObject.setData('editablemodel', editablemodel)>
		<cfset displayObject.setData('eventsModel', eventsmodel)>

	</cffunction>

</cfcomponent>