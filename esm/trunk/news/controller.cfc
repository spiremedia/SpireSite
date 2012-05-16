<cfcomponent name="News" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','news.models.newsItems').init(arguments.requestObj, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','news.models.logs2').init(arguments.requestObj, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','news.models.logs2').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
    <cffunction name="getTypesModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','news.models.newsTypes').init(arguments.requestObj, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','news.models.logs2').init(arguments.requestObj, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
    
    <!---<cffunction name="getTypesLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','news.models.newstypelogs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>--->
    
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(requestObject, userObj)>
		<cfset var log = getLogObj(requestObject, userObj)>

		<cfset displayObject.setData('list', model.getNewsItems())>
		<cfset displayObject.setData('recentActivity', log.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfif requestObject.isformurlvarset('sortkey')>
			<cfset displayObject.setWidgetOpen('mainContent','1,2')>
		</cfif>

	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(arguments.requestObject, arguments.userObj)>
		<cfset var lcl = structNew()>
		<cfset lcl.name = arguments.requestObject.getFormUrlVar('searchkeyword')>
		
		<cfset displayObject.setData('list', model.getNewsItems())>
		<cfset displayObject.setData('searchResults', model.like(lcl))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

	</cffunction>
	
	<cffunction name="addNews">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(requestObject, userObj)>
		<cfset var typemodel = getTypesModel(requestObject, userObj)>
		<cfset var logs = getlogObj(requestObject, UserObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getNewsItems())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('newsTypes', typemodel.getAll())>
        <cfset requestObject.setvar('type', 'mp3')>
        <cfset displayObject.setData('assets', dispatcher.callExternalModuleMethod('assets','GetAvailableAssets', requestObject, userobj))>
		<cfset displayObject.setData('availablePages', dispatcher.callExternalModuleMethod('pages', 'getPages', requestObject, userobj) )>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset model.Load(0)>
			<cfset displayObject.setData('info', model)>
		</cfif>

		<cfif requestObject.isformurlvarset('sortdir')>
        	<cfset displayObject.setWidgetOpen('mainContent','2')>
		</cfif>
			
		<!---<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>--->
	
	</cffunction>
	
	<cffunction name="editNews">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addnews(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveNews">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(requestObject, userobj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
			
		<cfif model.save()>
			<cfset lcl.id = model.getId()>
			<cfset lcl.msg = structnew()>
            
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "Updated News Item">
            <cfelse>
            	<cfset lcl.msg.message = "Saved News Item">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
            
			<cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "/news/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
            <cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeleteNews">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(requestObject, userobj)>
		
		<!--- <cfset model.load(requestObject.getformurlvar('id'))>
		<cfset lcl.filename = model.getFileName()> --->
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete news">
		</cfif>

		<cfif model.destroy(requestObject.getformurlvar('id'))>
			<!--- <cfif lcl.filename NEQ "">
				<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
				<cfset lcl.siteinfo = application.sites.getSite(arguments.userObj.getCurrentSiteId())>
				<cfset fs.delete(lcl.siteinfo.machineRoot & 'docs/news/' & lcl.filename)>
			</cfif> --->
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The News Item has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/news/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>News Item Deleted</div>">
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
		
		<cfset var model = getmodel(requestObject, userobj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getNewsItems())>
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editablemodel = getEditableModel(arguments.requestObject, arguments.userObj)>
		<cfset var newsTypesModel = getTypesModel(arguments.requestObject, arguments.userObj)>
	
		<cfset displayObject.setData('editablemodel', editablemodel)>
		<cfset displayObject.setData('newsTypesModel', newsTypesModel)>
	</cffunction>
	
	<cffunction name="GetAvailableNewsItems">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var model = createObject('component', 
				'news.models.news').init(requestObject, session.user)>
		
		<cfreturn model.getNewsItems()>
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

	<cffunction name="uploadFile">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
	
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>

	<!--- <cffunction name="uploadFileAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var info = structnew()>
		<cfset var id = requestObject.getFormUrlVar('id')>
		<cfset var model = getModel(requestObject, userObj)>
		<cfset var arrMsg = arrayNew(1)>
		<cfset var msg = "Please select a file to upload.">
		
		<cfset model.load(id)>
		
		<cfif requestObject.isFormUrlVarSet('filename') AND trim(requestObject.getFormUrlVar('filename')) NEQ ''>
			<cfset info.siteinfo = application.sites.getSite(session.user.getCurrentSiteId())>
		
			<cfset info.filetodelete = model.getField('filename')>
		
			<cfset info.mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'news', sitepath = info.siteinfo.machineroot, file = 'filename', filetodelete = info.filetodelete)>
			
			<cfif info.mainfile.success()>
				<cfset info.mainfilesize = info.mainfile.filesize()>
				<cfset info.mainfile = info.mainfile.savedName()>
				<cfset model.saveFileInfo(id=requestObject.getFormUrlVar('id'),
												filename=info.mainFile,
												filesize=info.mainfilesize)>
					
				<cfset msg = "File Uploaded! Reload news page (after saving any other info) to see file section.<br />">
			<cfelse>
				<cfset msg = "Failed to upload file.<br />">
			</cfif>				
		</cfif>
		
		<cflocation url="../uploadFile/?id=#requestObject.getFormUrlVar('id')#&msg=#msg#">
	</cffunction> --->
	
    <!--- TYPES --->
    
    	
	<cffunction name="BrowseTypes">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getTypesModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browsetypes") )>
	</cffunction>
	
    <cffunction name="viewNewsTypes">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getTypesModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getLogObj(requestObject, userobj)>

		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('recentActivity', logs.getRecentModuleHistory(requestObject.getModuleFromPath()))>

	</cffunction>
	
	<cffunction name="addNewsType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getTypesModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var lcl = structnew()>
		<!---<cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		
		<cfset lcl.newsTypes = model.getAll()>		
		
		<cfset displayObject.setData('list', lcl.newsTypes)>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', userobj)>

		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
		<cfelse>
			<cfset model.Load(0)>
			<cfset displayObject.setData('info', model)>
		</cfif>
	
		<cfset displayObject.setWidgetOpen('mainContent','1')>
		
	</cffunction>
	
	<cffunction name="editNewsType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addNewsType(displayObject,requestObject,userobj, dispatcher)>
	</cffunction>
	
	<cffunction name="SaveNewsType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getTypesModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
		
		<cfif model.save()>
			<cfset lcl.id = model.getId()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getformurlvar('id') EQ "">
				<cfset lcl.msg.message = "News Type Saved">
				<cfset lcl.msg.switchtoedit = lcl.id>
			<cfelse>
				<cfset lcl.msg.message = "News Type Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/news/Browsetypes/?id=#lcl.id#">
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
	
	<cffunction name="DeleteNewsType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getTypesModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletecontentgroup">
		</cfif>
				
		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The News Type has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/news/BrowseTypes/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>News Type Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>

</cfcomponent>