<cfcomponent name="news View" extends="resources.page">
    
	<cffunction name="preObjectLoad">
		<cfset var lcl = structnew()>
		<cfset lcl.boid = listlast(variables.requestObject.getFormUrlVar('path'), "/")>
		<cfset variables.bo = createObject("component", "modules.pages.models.stagedBlockPageObjects").init(requestObject)>
		<cfset variables.bo.load(lcl.boid)>

		<cfset lcl.views = application.views.getViews()>
		<cfset lcl.options = arraynew(1)>
		<cfloop collection="#lcl.views#" item="lcl.itm">
			<cfset lcl.viewinfo = lcl.views[lcl.itm]>
			<cfloop query="lcl.viewinfo">
				<cfif listfindnocase(lcl.viewinfo.modulename, variables.bo.getModule()) AND lcl.viewinfo.name EQ variables.bo.getName()>
					<cfset arrayappend(lcl.options, lcl.itm)>
				</cfif>
			</cfloop>
		</cfloop>
	
		<cfset variables.pageinfo.template = lcl.options[1]>
		
	</cffunction>
	
	<cffunction name="postObjectLoad">
		<cfset var lcl = structnew()>
		
		<cfset lcl.data = variables.bo.getData()>
		
		<cfif left(lcl.data,1) EQ '{'>
			<cfset lcl.data = deserializeJson(lcl.data)>
		</cfif>
		
		<cfif structkeyexists(lcl.data, 'moduleaction')>
			<cfset lcl.moduleaction = lcl.data.moduleaction>
		<cfelse>
			<cfset lcl.moduleaction = 'default'>
		</cfif>

		<cfset lcl.thismodule = application.modules.getModule(	
									module = variables.bo.getModule(), 
									requestObject = variables.requestObject,
									title = variables.bo.getTitle(), 
									data = lcl.data,
									pageref = this,
									possiblemodules = "",
									name = variables.bo.getName() )> 

		<cfset addObject(	variables.bo.getId(),
							variables.bo.getName(), 
							lcl.thismodule,
							variables.bo.getModule(),
							lcl.moduleaction,
							'unmanaged' )>
	</cffunction>
</cfcomponent>