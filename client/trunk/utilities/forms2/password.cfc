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
		
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<div class="formitem<cfif structkeyexists(lcl, "wrapclasses")> #lcl.wrapclasses#</cfif>">
			<label for="#lcl.id#">
				<cfif lcl.required><span class="required">*</span></cfif>
				#variables.forminfo.label#
			</label>
			<input <cfif structkeyexists(lcl, "formclasses")>class="#lcl.formclasses#"</cfif> <cfif structkeyexists(lcl, "formstyles")>style="#lcl.formstyles#"</cfif>
				type="password" 
					name="#variables.forminfo.name#" 
						id=""
							value="<cfif structkeyexists(variables.formdata, variables.forminfo.name)>#variables.formdata[variables.forminfo.name]#<cfelseif structkeyexists(variables.forminfo, 'default')>#variables.forminfo.default#</cfif>">
				<cfif structkeyexists(variables.forminfo,"footertext")>
					<div class="footertext">#variables.forminfo.footertext#</div>
				</cfif>
			</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>

</cfcomponent>