<cfcomponent name="event View" extends="resources.page">
	<cffunction name="preobjectLoad">
		<cfset variables.eventid = variables.requestObject.getFormUrlVar('path')>
		<cfset variables.eventid = listlast(variables.eventid, "/")>

		<cfset variables.event = createObject('component','modules.events.models.events').init(requestObject)>
		<cfset variables.eventInfo = variables.event.getEvent(variables.eventid)>

		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|News & Events~#variables.requestObject.getVar('newseventsPageID')#~/NewsAndEvents/|#variables.eventInfo.title#|">
		<cfset this.setField("navname", "Events")>
		<cfset variables.pageInfo.title = variables.eventInfo.title>
			
		<cfset variables.vdtr =  createObject('component', 'utilities.datavalidator').init()>
		<cfif variables.requestObject.isformurlvarset('email')>
			<cfset variables.event.registrationValidate(vdtr)>
			<cfif variables.vdtr.passValidation()>
				<cfset variables.event.registerUser(variables.eventid)>
				<cfset variables.event.sendConfirmationMessage(variables.eventInfo)>
			</cfif>
		</cfif> 

	</cffunction>
    
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		<!--- main title --->
		<cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('pagetitle', 'simpleContent', "", data)>

		<!--- mainContent --->
		<cfset data = structnew()>
		<cfset data.vdtr = variables.vdtr>
		<cfset data.eventInfo = variables.eventInfo>
		<cfset addObjectByModulePath('middleItem_1_Content', 'events', "", data, "eventdetail")>
		
		<cfif variables.requestObject.isformurlvarset('email') AND variables.vdtr.passValidation()>
			<!--- mainContent2 --->
			<cfset data = structnew()>
			<cfset addObjectByModulePath('middleItem_2_Content', 'events', "", data, "confirmation")>
		</cfif>
	</cffunction>
</cfcomponent>