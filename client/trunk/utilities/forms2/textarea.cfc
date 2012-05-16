<cfcomponent name="form2text" extends="utilities.forms2.leaf">
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
		<cfset lcl.required = structkeyexists(variables.forminfo, 'required')>
		<!--- <cfset lcl.validationerror = variables.vdtr.hasError(variables.forminfo.name)> --->
		
		<cfif structkeyexists(variables.forminfo,"wrapclasses")>
			<cfset lcl.wrapclasses = structkeylist(variables.forminfo.wrapclasses, " ")>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"formclasses")>
			<cfset lcl.formclasses = structkeylist(variables.forminfo.formclasses, " ")>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"formstyles")>
			<cfset lcl.formstyles = "">
			<cfloop collection="#variables.forminfo.formstyles#" item="lcl.itm">
				<cfset lcl.formstyles = lcl.formstyles & lcl.itm & ':' & variables.forminfo.formstyles[lcl.itm] & ';'>
			</cfloop>
		</cfif>
		<cfoutput>
		<cfsavecontent variable="lcl.h">
			<div class="formitem<cfif structkeyexists(lcl, "wrapclasses")> #lcl.wrapclasses#</cfif>">
            	<cfif #variables.forminfo.label# neq ""> <!--- added 5/10/10 [DW] - no point having empty labels take up screen real estate --->
                    <label for="#lcl.id#">
                        <cfif lcl.required><span class="required">*</span></cfif>
                        #variables.forminfo.label#
                    </label>
                </cfif>
                <textarea <cfif structkeyexists(lcl, "formclasses")>class="#lcl.formclasses#"</cfif> <cfif structkeyexists(lcl, "formstyles")>style="#lcl.formstyles#"</cfif>
                    name="#variables.forminfo.name#" 
                	id="#lcl.id#"
					><cfif structkeyexists(variables.formdata, variables.forminfo.name)>#variables.formdata[variables.forminfo.name]#<cfelseif structkeyexists(variables.forminfo, 'default')>#variables.forminfo.default#</cfif></textarea>
				<cfif structkeyexists(variables.forminfo,"footertext")>
					<div class="footertext">#variables.forminfo.footertext#</div>
				</cfif>
			</div>
		</cfsavecontent>
		</cfoutput>
		<cfreturn lcl.h>
	</cffunction>

</cfcomponent>