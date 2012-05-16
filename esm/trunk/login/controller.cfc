<cfcomponent name="Security" extends="resources.abstractController">
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfreturn this>
	</cffunction>
			
	<cffunction name="getModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','login.models.announcements').init(arguments.requestObj, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','login.models.logs').init(arguments.requestObj, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>		
			
	<cffunction name="getLoginModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','login.models.login').init(arguments.requestObj, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','login.models.logs').init(arguments.requestObj, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>		
	
	<cffunction name="LoginForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset displayObject.setData('requestObj',requestObject)>
	</cffunction>
	
	<cffunction name="chooseSite">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset displayObject.setData('siteslist', application.sites.getSites())>
		<cfset displayObject.setData('requestObject', requestObject)>
	</cffunction>
				
	<cffunction name="Welcome">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="dispatcher" required="true">

	</cffunction>
	
	<cffunction name="checkLogin">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var vdtr = "">
		<cfset var fields = structnew()>
		<cfset var lcl = structnew()>
		<cfset var user = "">
		<cfset var sites = application.sites.getSites()>
		<cfset var loginmodel = getLoginModel(requestObject, userObj)>
		<cfset var eventinfo = structnew()>
		
		<cfif NOT (requestObject.isformurlvarset('username') AND
			requestObject.isformurlvarset('password'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.message = "Please fill in the username and password fields.">
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
			
		<cfset fields.username=requestObject.getformurlvar('username')>
		<cfset fields.password=requestObject.getformurlvar('password')>
			
		<cfset vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset vdtr.validemail('username',fields.username, 'The username must be a valid email')>
		<cfset vdtr.lengthbetween('password',5,15,fields.password, 'The password must be between 5 and 15 chars long')>
		
		<cfif NOT vdtr.passValidation()>
			<cfset lcl.msg = structnew()>	
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
		<cfset user = dispatcher.callExternalModuleMethod('users','checkLoginCredentials', requestObject, userObj) >

		<cfif user.recordcount EQ 0>
			<cfset vdtr.addError('password','These credentials did not match what is in the database. Please retype them and try again.')>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	
		<cfset session.user.setUserName(user.username)>
		<cfset session.user.setFirstName(user.fname)>
		<cfset session.user.setLastName(user.lname)>
		<cfset session.user.setSuper(user.issuper)>
		<cfset session.user.setUserID(user.id)>
		
		<cfset eventinfo.id = user.Id>
		<cfset eventinfo.ip = CGI.REMOTE_ADDR>
		<cfset loginModel.observeEvent('user logged in', eventinfo)>
		
		<cfif Sites.recordcount EQ 1>
			<cfset session.user.setCurrentSiteId(sites.id, application.sites)>
		</cfif>
		
		<cfset requestobject.setVar('userid', user.id)>
		
		<!--- record user ip --->
		<cfset loginmodel.addSecurityIP( ip = CGI.REMOTE_ADDR, userid = user.id )>

		<cfif session.user.getCurrentSiteID() EQ 0>
			<cfset lcl.msg.relocate = '/login/chooseSite/'>
		<cfelse>
			<cfset lcl.msg.relocate = '/login/startPage/'>
		</cfif>
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="dumpuser">
		<cfset session.user.dump()>
		<cfabort>
	</cffunction>
	
	<cffunction name="addAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(requestObject, userObj)>
		<cfset var lcl = structnew()>	
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('info', model)>
		<cfelse>
			<cfset model.Load(0)>
			<cfset displayObject.setData('info', model)>
		</cfif>
		<cfreturn displayObject>		
	</cffunction>
	
	<cffunction name="editAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addAnnouncement(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>		
		<cfset var model = getmodel(requestObject, userObj)>				
		<cfset var requestvars = requestobject.getallformurlvars()>
				
		<cfparam name="requestvars.active" default="0">
		
		<cfset model.setValues(requestVars)>
		
		<cfif model.save()>
			<cfset lcl.id = model.getId()>
			<cfset lcl.msg = structnew()>
			
			<cfif requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "The Announcement has been Updated">
			<cfelse>
				<cfset lcl.msg.message = "The Announcement has been Added">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
			
	</cffunction>
	
	<cffunction name="changePassword">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

	</cffunction>
	
	<cffunction name="UpdatePassword">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var requestvars = duplicate(requestobject.getallformurlvars())>
		<cfset var model = dispatcher.callExternalModuleMethod('users','getUsersModel', requestObject, userObj) >
		
		<cfset model.load(arguments.userObj.getUserId())>				
		<cfset model.setValues(requestvars)>
		<!--- <cfset model.setId()> --->
					
		<cfset vdtr = model.validatePasswordChange()>
		
		<!-- file upload requests can't go thru ajax. resubmit -->
		<cfif vdtr.passValidation()>
			<cfset model.save()>
			<cfset lcl.msg.message = "Your password has been updated">
			<cfset lcl.msg.clearValidation = 1>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
		</cfif>
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getmodel(requestObject, userObj)>
		
		<cfif userObj.isallowed('login','Edit Announcement')>
			<!--- <cfset displayObject.setData('list', model.getAnnouncements(active = false))> --->
			<cfset displayObject.setData('list', model.getAll())>
		<cfelse>
			<!--- <cfset displayObject.setData('list', model.getAnnouncements())> --->
			<cfset displayObject.setData('list', model.getByActive(1))>
		</cfif>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="DeleteAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(requestObject, userObj)>

		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete Announcement">
		</cfif>
		
		<cfset model.load(requestObject.isformurlvarset('id'))>

		<cfif model.destroy(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Announcement has been deleted">
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>The Announcement has been deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
</cfcomponent>