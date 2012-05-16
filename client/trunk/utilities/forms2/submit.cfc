<cfcomponent name="form2submit" extends="utilities.forms2.leaf" output="false">
	
	<cffunction name="showHTML" output="false">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"formstyles")>
			<cfset lcl.styles = "">
            <cfloop collection="#variables.forminfo.formstyles#" item="lcl.itm">
                <cfset lcl.styles = lcl.styles & lcl.itm & ':' & variables.forminfo.formstyles[lcl.itm] & ';'>
            </cfloop>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"formclasses")>
			<cfset lcl.classes = structkeylist(variables.forminfo.formclasses, " ")>
		</cfif>
		
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<input <cfif structkeyexists(lcl, "classes")>class="#lcl.classes#"</cfif>
				<cfif structkeyexists(lcl, "styles")>style="#lcl.styles#"</cfif>
					type="submit" 
						name="#variables.forminfo.name#" 
							id="#lcl.id#"
								value="<cfif structkeyexists(variables.formdata, variables.forminfo.name)>#variables.formdata[variables.forminfo.name]#<cfelseif structkeyexists(variables.forminfo, 'default')>#variables.forminfo.default#</cfif>">
			</cfoutput>
		</cfsavecontent>

		<cfreturn lcl.h>
	</cffunction>
	
</cfcomponent>