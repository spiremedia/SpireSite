<cfcomponent name="" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','siteMemberTypes.models.membertypes').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','siteMemberTypes.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>	
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','siteMemberTypes.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		
		<cfset displayObject.setData('list', model.getMemberTypes())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
    	
	<cffunction name="addMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
						
		<cfset displayObject.setData('list', model.getMemberTypes())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('info', model.getMemberType(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('requestObject',requestObject)>
		<cfelse>
			<cfset displayObject.setData('info', model.getMemberType(0))>
			<cfset displayObject.setData('id', 0)>
		</cfif>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>
    
	<cffunction name="editMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addMemberType(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfset vdtr = model.validate(requestvars)>
		
		<cfset lcl.msg = structnew()>
		<cfif vdtr.passvalidation()>
			<cfset lcl.id = model.saveMember(requestvars)>
			
			<cfif  requestObject.getFormUrlVar('id') EQ "">
				<cfset lcl.msg.message = "Content Group Added">
				<cfset lcl.msg.message = "Member Type #requestvars.name# Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			<cfelse>
				<cfset lcl.msg.message = "Member Type #requestvars.name# Updated">
			</cfif>
			
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "../Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.clearvalidation = 1> 
		<cfelse>
			<cfset lcl.msg.validation = vdtr.getErrors()>
		</cfif>
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
   
	<cffunction name="DeleteMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletegroup">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteMemberType(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Member Type has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "../Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Member Type Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getMemberTypes())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
       
    <cffunction name="getAvailableMemberTypes">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var mktg = getModel(arguments.requestObject, arguments.userObj).getMemberTypes()>
		<!---><cfset queryaddrow(mktg)>
		<cfset querysetcell(mktg, 'name', 'default')>
        <cfset querysetcell(mktg, 'id', '')>--->
        
		<cfreturn mktg>
	</cffunction>

</cfcomponent>