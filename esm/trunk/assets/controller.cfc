<cfcomponent name="Assets" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getDefaultSort">
		<cfset var dfltsort = structnew()>
		<cfset dfltsort.sort = "assetGroups.name, assets.name">
		<cfreturn dfltsort>
	</cffunction>
	
	<!---
	<cffunction name="getGroupLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','assets.models.grouplogs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	--->
	<cffunction name="getGroupModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','assets.models.assetGroups').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(getLogObj(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getBulkUploadModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','assets.models.bulkUpload').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(getLogObj(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
    
    <cffunction name="getImageModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','assets.models.imageManipulation').init(arguments.requestObject, arguments.userObj)>
		<!---<cfset mdl.attachObserver(createObject('component','assets.models.grouplogs').init(arguments.requestObject, arguments.userObj))>--->
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','assets.models.assets').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(getLogObj(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','assets.models.logs2').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="viewAssetGroups">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getLogObj(requestObject, userobj)>
				
		<cfset displayObject.setData('list', model.getAssetGroups())>
		<cfset displayObject.setData('recentActivity', logs.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="addAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var lcl = structnew()>
		<!---<cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		
		<cfset lcl.assetGroups = model.getAssetGroups()>
		<cfset displayObject.setData('list', lcl.assetGroups)>
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
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.getLike("name",	requestObject.getformurlvar('search') ) )>
		</cfif>
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addAssetGroup(displayObject,requestObject,userobj, dispatcher)>
	</cffunction>
	
	<cffunction name="SaveAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
			
		<cfif model.save()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getformurlvar('id') EQ "">
				<cfset lcl.msg.message = "Asset Group Saved">
				<cfset lcl.msg.switchtoedit = model.getid()>
			<cfelse>
				<cfset lcl.msg.message = "Asset Group Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/BrowseGroups/?id=#model.getid()#">
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
	
	<cffunction name="DeleteAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deleteassetgroup">
		</cfif>
		
		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Group has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/BrowseGroups/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
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
	
		<cfset displayObject.setData('list', model.getAll(getDefaultSort()))>
		<cfset displayObject.setData('recentActivity', log.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var lcl = structNew()>
		<cfset lcl.name = requestObject.getFormUrlVar('searchkeyword')>

		<cfset displayObject.setData('list', model.getAll(getDefaultSort()))>
		<cfset displayObject.setData('searchResults', model.like(lcl))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="AddAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var grpmodel = getGroupModel(argumentcollection = arguments)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
		
		<cfset displayObject.setData('list', model.getAll(getDefaultSort()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('groupTypes', grpmodel.getAssetGroups())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('link', '/docs/assets/#model.getId()#/#model.getFilename()#')>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset model.Load(0)>
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

		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editasset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addasset(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
		
	<cffunction name="SaveAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfparam name="requestvars.assetGroupId" default="">
		
		<cfset model.setValues(requestVars)>
				
		<!-- file upload requests can't go thru ajax. resubmit -->
		<cfif model.save()>			
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getformurlvar('id') EQ "">
				<cfset lcl.msg.message = "Asset Saved">
				<cfset lcl.msg.switchtoedit = model.getid()>
			<cfelse>
				<cfset lcl.msg.message = "Asset Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/Browse/?id=#model.getid()#">
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
	
	<cffunction name="DeleteAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfset model.load(requestObject.getformurlvar('id'))>
		
		<cfif NOT requestObject.isformurlvarset('id') OR NOT isValid('UUID', requestObject.getFormUrlVar("id"))>
			<cfthrow message="valid id not provided to delete asset">
		</cfif>

		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfif DirectoryExists(requestObject.getVar('machineroot') & 'docs/assets/#requestObject.getformurlvar('id')#')>
				<cfdirectory action="delete" directory="#requestObject.getVar('machineroot')#docs/assets/#requestObject.getformurlvar('id')#" recurse="true">
			</cfif>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Asset has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Asset Deleted</div>">
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
		
		<cfset displayObject.setData('list', model.getAll(getDefaultSort()))>
		
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
		
		<cfset displayObject.setData('list', model.getAssetGroups())>
		
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

		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getAvailableAssetGroups">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn model.getAssetGroups()>
	</cffunction>
	
	<cffunction name="GetAvailableAssets">
			<cfargument name="requestObject" required="true">
			<cfargument name="userObj" required="true">
			
			<cfset var model = getModel(requestObject, session.user)>
			<cfset var sortstruct = structnew()>
			<cfset sortstruct.sort = "assetgroups.name, assets.name">
			<cfreturn model.getAll(sortstruct)>
	</cffunction>
	
	<cffunction name="GetAvailableImageAssets">
			<cfargument name="requestObject" required="true">
			<cfargument name="userObj" required="true">
			
			<cfset var model = getModel(requestObject, session.user)>
			<cfreturn model.getAllAvailableImages()>
	</cffunction>
	
	<cffunction name="viewImage">
    	<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
		<cfset lcl.filepath = requestObject.getVar('machineroot') & 'docs/assets/#id#/' & lcl.filename>
		<cfif fileexists(lcl.filepath)>
            <cfheader name="content-disposition" value="inline; filename=#lcl.filename#"/>
            <cfcontent type="image/#ListLast( lcl.filename, '.' )#" file="#requestObject.getVar('machineroot') & 'docs/assets/#id#/' & lcl.filename#" /><cfabort>
        <cfelse>
        	<cfheader name="content-disposition" value="inline; filename=#lcl.filename#"/>
            <cfcontent type="image/gif" file="#requestObject.getVar('machineroot')#ui/images/missingimage.gif"/><cfabort>
        </cfif>
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
        
        <cfif requestObject.isFormUrlVarSet("imgaction")>
        	<cfset lcl.imgaction = requestObject.getFormUrlVar("imgaction")>
        <cfelse>
        	<cfset lcl.imgaction = "">
        </cfif>
        
        <cfset model.load(id)>
		<cfset lcl.filename = model.getField('filename')>
        <cfset lcl.imagepath = requestObject.getVar('machineroot') & "docs/assets/#id#/" & lcl.filename>
		
        <cfswitch expression="#lcl.imgaction#">
        	<cfcase value="crop">
            	<cfset checkImagebackup(lcl.imagepath, id)>
            	<cfset imgmodel.crop(	imgfile = lcl.imagepath,
										x = requestObject.getFormUrlVar('x'),
										y = requestObject.getFormUrlVar('y'),
										h = requestObject.getFormUrlVar('h'),
										w = requestObject.getFormUrlVar('w')
				)>
			</cfcase>
            <cfcase value="rotate">
            	<cfset checkImagebackup(lcl.imagepath, id)>
            	<cfset imgmodel.rotate(	imgfile = lcl.imagepath,
										degrees = requestObject.getFormUrlVar('degrees')							
				)>
            </cfcase>
            <cfcase value="resize">
            	<cfset checkImagebackup(lcl.imagepath, id)>
            	<cfset imgmodel.resize(	imgfile = lcl.imagepath,
										w = requestObject.getFormUrlVar('w'),
										h = requestObject.getFormUrlVar('h')							
				)>
            </cfcase>
            <cfcase value="revert">
            	<cfset lcl.backupimagedirectory = "#listdeleteat(lcl.imagepath, listlen(lcl.imagepath, "/"), "/")#/bkimg">
				<cfset lcl.backupimagepath = lcl.backupimagedirectory & "/" & listlast(lcl.imagepath, "/")>

                <cfif NOT fileexists(lcl.backupimagepath)>
                    <cfset displayObject.sendJson(info)>
                </cfif>
                
                <cffile action="copy" destination="#lcl.imagepath#" source="#lcl.backupimagepath#" mode="644">
            </cfcase>
        </cfswitch>
		        
		<cfset info = imgmodel.getInfo(lcl.imagepath)>
        <cfset info.imagepath = "/docs/assets/#id#/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
    
    <cffunction name="checkImagebackup" access="private">
    	<cfargument name="imagepath" required="yes">
        <cfargument name="id" required="yes">
		<cfset var backupimagedirectory = "#listdeleteat(imagepath, listlen(imagepath, "/"), "/")#/bkimg">
        <cfset var backupimagepath = backupimagedirectory & "/" & listlast(imagepath, "/")>

        <cfif fileexists(backupimagepath)>
        	<cfreturn>
        </cfif>
        
		<cfif NOT directoryexists(backupimagedirectory)>
            <cfdirectory action="create" directory="#backupimagedirectory#" mode="644">
        </cfif>
        
        <cffile action="copy" source="#imagepath#" destination="#backupimagepath#" mode="644">
    </cffunction>
    <!---
    <cffunction name="eaImgCrop">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = "">
		
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
     
		
       
        <cfset info = imgmodel.getInfo(requestObject.getVar('machineroot') & "docs/assets/" & lcl.filename)>
        <cfset info.imagepath = "/docs/assets/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
    
    <cffunction name="eaImgRotate">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = "">
		
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
     
		
       
        <cfset info = imgmodel.getInfo(requestObject.getVar('machineroot') & "docs/assets/" & lcl.filename)>
        <cfset info.imagepath = "/docs/assets/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
 
    <cffunction name="eaImgresize">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = "">
		
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
     
		
       
        <cfset info = imgmodel.getInfo(requestObject.getVar('machineroot') & "docs/assets/" & lcl.filename)>
        <cfset info.imagepath = "/docs/assets/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
	   --->
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editablesmodel = getEditableModel(arguments.requestObject, arguments.userObj)>
		<cfset var assetsModel = getModel(arguments.requestObject, arguments.userObj)>
		<cfset var grpmodel = getGroupModel(argumentcollection = arguments)>
		
		<cfset displayObject.setData('editablesmodel', editablesmodel)>
		<cfset displayObject.setData('groupTypes', grpmodel.getAssetGroups())>
		<cfset displayObject.setData('assetsmodel', assetsmodel)>

		<cfreturn displayObject>
	</cffunction>
	    
    <cffunction name="tinymceUpload">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfset lcl.assetGroups = model.getAll()>
				
		<cfset displayObject.setData('grouptypes', lcl.assetGroups)>
	    
        <cfreturn displayObject>
	</cffunction>
        
    <cffunction name="tinymceUploadAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfset var requestvarsdup = duplicate(requestVars)>
		
		<cfset structdelete(requestvarsdup, 'filename')>
		
		<cfparam name="requestvarsdup.description" default="">
		<cfparam name="requestvarsdup.startdate" default="">
		<cfparam name="requestvarsdup.enddate" default="">
		
		<cfset requestvarsdup.active = 1>
		
		<cfset model.setValues(requestVarsdup)>
		
		<cfif model.save()>
			<cfset info.id = model.getid()>
		<cfelse>
			<cfset displayObject.showHTML("<script>parent.showErrors('#rereplace(model.getValidator().getFormattedErrors(),"[\r\t\n ]+"," ","all")#')</script>")>
		</cfif>
			
		<cfset info.filename = "filename">
		<cfset lcl.filename = model.uploadAssetFileInfo(info)>

		<cfset displayObject.showHTML("<script>parent.FileBrowserDialogue.imageChosen('#info.id#')</script>")>	  
    </cffunction> 
	
	<cffunction name="listedassetUpload">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfif requestObject.isFormUrlVarSet("id")>
			<cfset model.load(requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset model.load(0)>
		</cfif>
		
		<cfset displayObject.setData('model', model)>
		
        <cfreturn displayObject>
	</cffunction>
        
    <cffunction name="listedassetUploadAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var groupmodel = getGroupModel(argumentcollection = arguments)>
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfset var requestvarsdup = duplicate(requestVars)>
		
		<cfset structdelete(requestvarsdup, 'filename')>
		
		<cfparam name="requestvarsdup.description" default="">
		<cfparam name="requestvarsdup.startdate" default="">
		<cfparam name="requestvarsdup.enddate" default="">
		
		<cfset requestvarsdup.active = 1>
		
		<!--- if this is a new asset, deal with the groups --->
		<cfif requestObject.getFormUrlVar("id") EQ "">
			<cfset lcl.grp = groupmodel.getByName(requestObject.getFormUrlVar("groupname"))>
			<cfif lcl.grp.recordcount>
				<cfset requestVarsDup.assetgroupid = lcl.grp.id>
			<cfelse>
				<cfset groupmodel.clear()>
				<cfset groupmodel.setName(requestObject.getFormUrlVar("groupname"))>	
				<cfset groupmodel.setisAssetsList(1)>		
				<cfif NOT groupmodel.save()>
					<cfdump var=#groupmodel.getValidator().getErrors()#><cfabort>
				</cfif>
				<cfset requestVarsDup.assetgroupid = groupmodel.getId()>
			</cfif>
		</cfif>
		
		<cfset model.setValues(requestVarsdup)>
		
		<cfif model.save()>
			<cfset info.id = model.getid()>
		<cfelse>
			<cfset displayObject.showHTML("<script>parent.showErrors('#rereplace(model.getValidator().getFormattedErrors(),"[\r\t\n ]+"," ","all")#')</script>")>
		</cfif>
		
		<cfif trim(requestObject.getFormUrlVar("filename")) NEQ "">
			<cfset info.filename = "filename">
			<cfset lcl.filename = model.uploadAssetFileInfo(info)>
		</cfif>
		
		<cfset displayObject.showHTML("<script>parent.parent.resetAssetListing('#requestObject.getFormUrlVar("groupname")#');</script>")>	  
    </cffunction> 
    
     <cffunction name="assetlistinghtml">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset lcl.al = getUtility("assetslistings").init(requestObject, userObj)>
		<cfset lcl.al.setAssetGroupName(requestObject.getFormUrlVar("groupname"))>
		
		<cfset displayObject.showHTML(lcl.al.showHTML())>	  
    </cffunction> 

	<cffunction name="uploadAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="uploadAssetAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var info = structnew()>
		
		<cfset info.filename = "imagefile">
		<cfset info.id = requestObject.getFormUrlVar("id")>

		<cfset model.load(info.id)>
		
		<cfif len(trim(requestObject.GetFormUrlVar(info.filename))) EQ 0>
			<cfset userobj.setFlash("Please upload an Asset")>
			<cflocation url="/assets/uploadAsset/?id=#info.id#" addtoken="no">
		</cfif>

		<cfset lcl.msg = structnew()>
		
		<cfset lcl.filename = model.uploadAssetFileInfo(info)>
		<cfset userObj.setFlash("Asset Uploaded")>
		<cflocation url="/assets/editAsset/?id=#requestObject.getFormUrlVar("id")#" addtoken="no">

	</cffunction>
	
	<cffunction name="bulkUpload">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var log = getLogObj(requestObject, userObj)>
	
		<cfset displayObject.setData('list', model.getAll(getDefaultSort()))>

	</cffunction>
	
	<cffunction name="bulkUploadAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var info = structnew()>
		<cfset var fiulsvobj = createobject("component", "utilities.fileuploadandsave")>
		<cfset var filesystemobj = createobject("component", "utilities.filesystem")>
		<cfset var fileuploadstatus = "">
		<cfset var workingdir = requestObject.getVar("machineroot") & 'docs/assetsbulkuploadwork/'>
		<cfset lcl.msg = structnew()>
		
		<cfset info.filename = "assetszipfile">
		
		<cfif len(trim(requestObject.GetFormUrlVar(info.filename))) EQ 0>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "Please upload a zip file">
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
		<!--- check working dir exists otherwise create --->
		<cfif NOT directoryexists(workingdir)>
			<cfdirectory action="create" directory="#workingdir#">
		</cfif>
		
		<!--- clear the working directory --->
		<cfset filesystemobj.cleardirectory(workingdir)>

		<cfset fileuploadstatus = fiulsvobj.init("assetsbulkuploadwork", requestobject.getVar("machineroot"), "assetszipfile", "", "zip")>
		
		<cfif NOT fileuploadstatus.success()>
			<cfset lcl.msg.message = "Upload Failed : " & fileuploadstatus.reason()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

		<!--- invoke here --->
		<cfset lcl.groupuploadmdl = getBulkUploadModel(requestObject, userobj)>
	
		<cfset lcl.groupuploadmdl.setFilename(fileuploadstatus.savedname())>
	
		<cfif NOT lcl.groupuploadmdl.validate()>
			<cfset lcl.msg.message = lcl.groupuploadmdl.getValidationIssues()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		<cfset lcl.assetModel = getModel(requestObject, userobj)>
		<cfset lcl.groupModel = getGroupModel(requestObject, userobj)>
		
		<cfset lcl.r = lcl.groupuploadmdl.process(lcl.assetmodel, lcl.groupmodel)>

		<cfset lcl.msg.message = "Groups : Added " & lcl.r.groupsadded>
		<cfset lcl.msg.message = lcl.msg.message & "<br>Assets : Added " & lcl.r.assetsadded & ", updated " & lcl.r.assetsupdated>
		<cfset lcl.msg.ajaxupdater = structnew()>
		<cfset lcl.msg.ajaxupdater.url = "/Assets/Browse/">
		<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
		<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
		<cfset lcl.msg.clearvalidation = 1>
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
</cfcomponent>