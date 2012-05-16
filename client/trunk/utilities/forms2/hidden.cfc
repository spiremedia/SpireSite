<cfcomponent name="form2hidden" extends="utilities.forms2.leaf">
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>
		
		<cfoutput>
		<cfsavecontent variable="lcl.h">
			<input 
				type="hidden" 
					name="#variables.forminfo.name#" 
						id="<cfif structkeyexists(variables.forminfo,"id")>#variables.forminfo.id#<cfelse>#variables.forminfo.name#</cfif>"
							value="<cfif structkeyexists(variables.formdata, variables.forminfo.name)>#variables.formdata[variables.forminfo.name]#<cfelseif structkeyexists(variables.forminfo, 'default')>#variables.forminfo.default#</cfif>">
		</cfsavecontent>
		</cfoutput>
		
		<cfreturn lcl.h>
	</cffunction>
	
</cfcomponent>