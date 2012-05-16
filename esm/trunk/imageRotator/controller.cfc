<cfcomponent name="homeImages" extends="resources.abstractControllerweditables">

	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var mdl = getImagesmodel(requestObject, userObj)>
				
		<cfset displayObject.setData('browse', mdl.getAll())>
	</cffunction>

	<cffunction name="getImagesModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "imageRotator.models.images").init(arguments.requestObj, arguments.userObj)>
		<cfreturn m>
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
	
	<cffunction name="addImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var mdl = getImagesmodel(requestObject, userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('browse', mdl.getAll())>
			
		<cfif requestObject.isformurlvarset('id')>
			<cfset mdl.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('history', queryNew("hi"))>
			<cfset displayObject.setData('Image', mdl)>
			<cfset displayObject.setData('images', getImageParams())>
			<cfif mdl.getField('filename') NEQ "">
				<cfset displayObject.setWidgetOpen('mainContent','1,2')>
			</cfif>
		<cfelse>
			<cfset mdl.Load(0)>
			<cfset displayObject.setData('Image', mdl)>
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
	
	<cffunction name="editImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addImage(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="DeleteImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getImagesmodel(requestObject, userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id') OR NOT isValid('UUID', requestObject.getFormUrlVar("id"))>
			<cfthrow message="valid id not provided to delete image">
		</cfif>

		<cfif mdl.delete(requestObject.getformurlvar('id'))>
			<cfif DirectoryExists(requestObject.getVar('machineroot') & 'docs/imagerotator/#requestObject.getformurlvar('id')#')>
				<cfdirectory action="delete" directory="#requestObject.getVar('machineroot')#docs/imagerotator/#requestObject.getformurlvar('id')#" recurse="true">
			</cfif>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Image Item has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/imageRotator/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Image Item Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="SaveImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getImagesmodel(requestObject, userobj)>
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfparam name="requestvars.active" default="0">

		<cfset mdl.setValues(requestVars)>
			
		<cfif mdl.save()>
			<cfset lcl.id = mdl.getId()>
			<cfset lcl.msg = structnew()>
            
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "Updated Image Item">
            <cfelse>
            	<cfset lcl.msg.message = "Saved Image Item">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
            
			<cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "/imageRotator/Browse/?id=#lcl.id#">
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

		<cfset var mdl = getImagesmodel(requestObject, userObj)>
		<cfset var srch = structnew()>
		<cfset displayObject.setData('browse', mdl.getAll())>
		
		<cfset srch.name = arguments.requestObject.getFormUrlVar('searchkeyword')>
		<cfset displayObject.setData('searchResults', mdl.like(srch))>
	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var mdl = getImagesmodel(requestObject, userObj)>
		
		<cfset displayObject.setData('browse', mdl.getAll())>
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="uploadImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

	</cffunction>

	<cffunction name="uploadImageAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var lcl = structnew()>
		<cfset var info = structnew()>
		<cfset var model = getImagesmodel(requestObject, userObj)>
		
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

		<cfif lcl.flagFileUploaded>
			<cfset userobj.setFlash("Image Uploaded")>
			<cfset lcl.msg.relocate = "../editImage/?id=#requestObject.getFormUrlVar("id")#">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg.message = "Please upload an image.">
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editablemodel = getEditableModel(arguments.requestObject, arguments.userObj)>

		<cfset displayObject.setData('editablemodel', editablemodel)>
	</cffunction>
	
</cfcomponent>
