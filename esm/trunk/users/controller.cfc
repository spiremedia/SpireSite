<cfcomponent name="Users" extends="resources.abstractController">
	
	<cffunction name="getUsersModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset mdl = createObject('component','users.models.users').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(getLogObj(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','users.models.logs2').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getLogObj(arguments.requestObject, arguments.userObj)>
		<cfset var searchstruct = structnew()>
		<cfset searchstruct.sort = "lname">
		<cfset displayObject.setData('userlist', usermodel.getAll(searchstruct))>
		<cfset displayObject.setData('recentActivity', logs.getRecentModuleHistory(requestObject.getModuleFromPath()))>

	</cffunction>
	
	<cffunction name="adduser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var worldinfo = createObject('component','utilities.worldinfo').init(arguments.requestObject)>			
		<cfset var searchstruct = structnew()>
		<cfset searchstruct.sort = "lname">
		<cfset displayObject.setData('userlist', usermodel.getAll(searchstruct))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('states', worldinfo.getStates())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('itemhistory', logs.getUsersActivities(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('userinfo', usermodel.getById(	requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('userid', requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('userinfo', usermodel.getById(0))>
			<cfset displayObject.setData('userid', 0)>
		</cfif>
		
		<cfset displayObject.setWidgetOpen('mainContent','1,2')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('usersearch', 
				usermodel.searchUser(
					requestObject.getformurlvar('search')))>
		</cfif>

	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var searchstruct = structnew()>
		
		<cfset searchstruct.sort = "lname">
		<cfset displayObject.setData('userlist', usermodel.getAll(searchstruct))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

		<cfset displayObject.setData('searchinfo', 
			usermodel.search(	requestObject.getformurlvar('searchkeyword')))>
		
	</cffunction>

	<cffunction name="edituser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addUser(displayObject,requestObject,userobj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveUser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfset usermodel.setValues(requestVars)>
			
		<cfif usermodel.save()>
			<cfset lcl.id = usermodel.getId()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getformurlvar('id') EQ ''>
				<cfset lcl.msg.message = "User Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			<cfelse>
				<cfset lcl.msg.message = "User Saved">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Users/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.clearvalidation = 1>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = userModel.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		<!--- <cfset vdtr = usermodel.validate()> 
		<cfif usermodel.save()>
			<cfset usermodel.save()>
			<cfset lcl.id = usermodel.getId()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "User Saved">
			<cfelse>
				<cfset lcl.msg.message = "User Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Users/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.clearvalidation = 1>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>--->
	
	</cffunction>

	<cffunction name="DeleteUser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var userm = getUsersModel(arguments.requestObject, arguments.userObj)>

		<cfif userm.delete(requestObject.getformurlvar('id')) >
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The User has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Users/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>The User has been Deleted </div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = userm.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var searchstruct = structnew()>			
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('userid', requestObject.getformurlvar('id'))>	
		</cfif>

		<cfset searchstruct.sort = "lname">
		<cfset displayObject.setData('userlist', usermodel.getAll(searchstruct))>
		
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="getAvailableUsers">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn userModel.getAll()>
	</cffunction>
	
	<cffunction name="checkLoginCredentials">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var conditions = structnew()>		
		
		<cfset conditions.username = requestObject.getFormUrlVar('username')>
		<cfset conditions.password = hash(requestObject.getFormUrlVar('password'))>
		<cfset conditions.active = 1>

		<cfreturn userModel.getAll(conditions)>
	</cffunction>
</cfcomponent>