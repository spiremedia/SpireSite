<cfcomponent name="Galleries" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getGroupModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','videos.models.videoGroups').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','videos.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
    
    <cffunction name="getImageModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','utilities.imageManipulation').init(arguments.requestObject, arguments.userObj)>
		<!---<cfset mdl.attachObserver(createObject('component','galleries.models.grouplogs').init(arguments.requestObject, arguments.userObj))>--->
		<cfreturn mdl/>
	</cffunction>
	
	 <cffunction name="getImageParams">
		<cfset var modulexml = "">
		<cfset var xml = structnew()>
		<cfset var rq = querynew("name,maxwidth,maxheight,extensionmod,resize,alloweableExtensions")>
		<cfinclude template="modulexml.cfm">		
		<cfset xml.imageinfo = xmlsearch(modulexml,"//images/img")>
		
		<cfloop from="1" to="#arraylen(xml.imageinfo)#" index="xml.itr">
			<cfset xml.xmlitem = xml.imageinfo[xml.itr]>
			<cfset queryaddrow(rq)>
			<cfloop list="#rq.columnlist#" index="xml.itr2">
				<cfset querysetcell(rq, xml.itr2, xml.xmlitem.xmlattributes[xml.itr2])>
			</cfloop>
		</cfloop>

		<cfreturn rq/>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','videos.models.videos').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','videos.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','videos.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="viewVideoGroups">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getLogObj(requestObject, userobj)>
		
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('recentActivity', logs.getRecentModuleHistory(requestObject.getModuleFromPath()))>

	</cffunction>
	
	<cffunction name="addVideoGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var vmodel = getModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var lcl = structnew()>
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		
		<cfset lcl.videoGroups = model.getAll()>
		
		<cfset displayObject.setData('list', lcl.videoGroups)>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', userobj)>
		<cfset displayObject.setData('videolist', vmodel.getAll())>

		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset model.load(0)>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('id', 0)>
		</cfif>
	
		<cfset displayObject.setWidgetOpen('mainContent','1')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

	</cffunction>
	
	<cffunction name="editVideoGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addVideoGroup(displayObject,requestObject,userobj, dispatcher)>
	</cffunction>
	
	<cffunction name="SaveVideoGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfif (requestvars.id EQ "" AND NOT userObj.isAllowed("Videos", "Add Video Group"))
				OR (requestvars.id NEQ "" AND NOT userObj.isAllowed("Videos", "Edit Video Group"))>
			<cfset lcl.message = "You do not have permission to save this item">
			<cfset displayObject.sendJson( lcl )>
		</cfif>

		<cfset model.setValues(requestVars)>
			
		<cfif model.save()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getformurlvar('id') EQ "">
				<cfset lcl.msg.message = "Video Group Saved">
				<cfset lcl.msg.switchtoedit = model.getid()>
			<cfelse>
				<cfset lcl.msg.message = "Video Group Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Videos/BrowseGroups/?id=#model.getId()#">
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
	
	<cffunction name="DeleteVideoGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletecontentgroup">
		</cfif>
		
		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Group has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/videos/BrowseGroups/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Group Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>

	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var log = getLogObj(requestObject, userObj)>

		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('recentActivity', log.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var lcl = structNew()>
		<cfset lcl.name = requestObject.getFormUrlVar('searchkeyword')>
		
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('searchResults', model.like(lcl))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

	</cffunction>
	
	<cffunction name="AddVideo">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var typesmodel = getGroupmodel(argumentcollection = arguments)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<!--- <cfset displayObject.setData('groupTypes', typesmodel.getAll())> --->
		
		<cfif requestObject.isformurlvarset('id')>  
			<cfset model.load( requestObject.getformurlvar('id') )>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('link', '/docs/videogalleries/#model.getField('videofilename')#')>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('images', getImageParams())>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
			<cfif model.getField('videofilename') NEQ "">
				<cfset displayObject.setWidgetOpen('mainContent','1,2')>
			</cfif>
		<cfelse>
			<cfset model.load(0)>
			<cfset displayObject.setData('info', model)>
		</cfif>
		
		<cfif requestObject.isformurlvarset('sortdir')>
			<cfset displayObject.setWidgetOpen('mainContent','1,3')>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

	</cffunction>
	
	<cffunction name="editVideo">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addVideo(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
		
	<cffunction name="SaveVideo">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfparam name="requestvars.ImageGroupId" default="">
		<cfset model.setValues(requestVars)>

		<cfif model.save()>
			<cfset lcl.id = model.getId()>
			<cfset lcl.msg = structnew()>
			
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/videos/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'> 
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.clearvalidation = 1>
			
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Video has been Updated">
			<cfelse>
				<cfset lcl.msg.message = "The Video has been Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			</cfif> 
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
		</cfif>
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="uploadVideo">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

	</cffunction>
	
	<cffunction name="uploadVideoAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var info = structnew()>
		<cfset var model = getmodel(requestObject, userObj)>
		
		<cfif NOT isValid('UUID', requestObject.getFormUrlVar("id"))>
			<cfset lcl.msg.message = "Incorrect ID">
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
		<cfset info.id = requestObject.getFormUrlVar("id")>
		<cfset model.load(info.id)>
		<cfset lcl.msg = structnew()>
		<cfset lcl.imgparams = getImageParams()>
		<cfset lcl.fileList = ValueList(lcl.imgparams.name)>
		<cfset lcl.flagFileUploaded = false>
	
		<cfloop query="lcl.imgparams">
			<cfset info.filename = name>
			<cfset info.alloweableExtensions = alloweableExtensions>
			<cfif len(trim(requestObject.GetFormUrlVar(info.filename))) GT 0>
				<cfset lcl.uploadInfo =  model.uploadImageFileInfo(info)>
				<cfif lcl.uploadInfo.success EQ 0>
					<cfset lcl.msg.message = lcl.uploadInfo.reason>
					<cfset displayObject.sendJson( lcl.msg )>
				<cfelse>
					<cfset lcl.flagFileUploaded = true>
					<cfif resize EQ 1>
						<cfset model.resizeImage(info,maxwidth,maxheight,getImageModel(arguments.requestObject, arguments.userobj))>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>	

		<!--- <cfset info.filename = "videofilename">
		<cfset model.uploadImageFileInfo(info)> --->
		<cfif lcl.flagFileUploaded>
			<cfset userobj.setFlash("Video Uploaded")>
			<cfset lcl.msg.relocate = "../editVideo/?id=#requestObject.getFormUrlVar("id")#">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg.message = "Please upload a video and/or thumbnail.">
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>	
	</cffunction>
	
	<cffunction name="deleteVideo">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfif NOT requestObject.isformurlvarset('id') OR NOT isValid('UUID', requestObject.getFormUrlVar("id"))>
			<cfthrow message="valid id not provided to delete video">
		</cfif>

		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfif DirectoryExists(requestObject.getVar('machineroot') & 'docs/videos/#requestObject.getformurlvar('id')#')>
				<cfdirectory action="delete" directory="#requestObject.getVar('machineroot')#docs/videos/#requestObject.getformurlvar('id')#" recurse="true">
			</cfif>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Video has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/videos/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Video Deleted</div>">
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
		
		<cfset var model = getmodel(argumentcollection = arguments)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getAll())>
		
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="BrowseGroups">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getAll())>
		
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browseGroups") )>
	</cffunction>
	
	<cffunction name="groupSearch">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var lcl = structNew()>
		<cfset lcl.name = requestObject.getFormUrlVar('searchkeyword')>
		
		<cfset displayObject.setData('list', model.getAll())>
		<cfset displayObject.setData('searchResults', model.like(lcl))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>

	</cffunction>
	
	<cffunction name="getAvailableImageGroups">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn model.getAll()>
	</cffunction>
	
	<cffunction name="GetAvailableGalleries">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var model = getModel(requestObject, session.user)>
		
	</cffunction>
	
    <cffunction name="eaImg">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = structnew()>
        <cfset var id = requestObject.getFormUrlVar("id")> 
        <cfset var imgparams = getImageParams()>
        <cfif requestObject.isFormUrlVarSet("imgaction")>
        	<cfset lcl.imgaction = requestObject.getFormUrlVar("imgaction")>
        <cfelse>
        	<cfset lcl.imgaction = "">
        </cfif>
        
        <cfset model.load(id)>
		<cfset lcl.filename = model.getField('filename')>
        <cfset lcl.imagepath = requestObject.getVar('machineroot') & "docs/videogalleries/#id#/" & lcl.filename>
		
        <cfswitch expression="#lcl.imgaction#">
        	<cfcase value="crop">
            	<cfset checkImagebackup(lcl.imagepath, id)>
				<cfset getLogObj(requestObject,userObj).event("Crop", model)>
            	<cfset imgmodel.crop(	imgfile = lcl.imagepath,
										x = requestObject.getFormUrlVar('x'),
										y = requestObject.getFormUrlVar('y'),
										h = requestObject.getFormUrlVar('h'),
										w = requestObject.getFormUrlVar('w')
				)>
				<cfset model.resizeImage(imgparams, imgmodel)>
				
			</cfcase>
            <cfcase value="rotate">
            	<cfset checkImagebackup(lcl.imagepath, id)>
				<cfset getLogObj(requestObject,userObj).event("Rotate", model)>
            	<cfset imgmodel.rotate(	imgfile = lcl.imagepath,
										degrees = requestObject.getFormUrlVar('degrees')							
				)>
				<cfset model.resizeImage(imgparams, imgmodel)>
            </cfcase>
            
            <cfcase value="revert">
				<cfset getLogObj(requestObject,userObj).event("Revert", model)>

                <cffile action="copy" source="#rereplacenocase(lcl.imagepath, "\.(jpg|png)$", "_orig.\1")#" destination="#lcl.imagepath#" mode="644">
            	<cfset model.resizeImage(imgparams, imgmodel)>
			</cfcase>
        </cfswitch>
		        
		<cfset info = imgmodel.getInfo(lcl.imagepath)>
        <cfset info.imagepath = "/docs/videogalleries/#id#/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
	
	<cffunction name="viewImage">
    	<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>

		<cfheader name="content-disposition" value="inline; filename=#lcl.filename#"/>
		<cfcontent type="image/#ListLast( lcl.filename, '.' )#" file="#requestObject.getVar('machineroot') & 'docs/videogalleries/#model.getField("id")#/' & lcl.filename#" /><cfabort>
	</cffunction>
    
    <cffunction name="checkImagebackup" access="private">
    	<cfargument name="imagepath" required="yes">
        <cfargument name="id" required="yes">
		<cfset var backupimagedirectory = "#listdeleteat(imagepath, listlen(imagepath, "/"), "/")#/bkimg_#id#">
        <cfset var backupimagepath = backupimagedirectory & "/" & listlast(imagepath, "/")>

        <cfif fileexists(backupimagepath)>
        	<cfreturn>
        </cfif>
        
		<cfif NOT directoryexists(backupimagedirectory)>
            <cfdirectory action="create" directory="#backupimagedirectory#" mode="644">
        </cfif>
        
        <cffile action="copy" source="#imagepath#" destination="#backupimagepath#" mode="644">
    </cffunction>

	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editModel = getEditableModel(requestObject, userobj)>
		
		<cfset var groupsModel = getGroupModel(requestObject, userObj)>
		
		<cfset displayObject.setData('editModel', editModel)>
		<cfset displayObject.setData('groupModel', groupsModel)>
		
	</cffunction>
</cfcomponent>