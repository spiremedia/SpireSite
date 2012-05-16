<cfcomponent name="form2text" extends="utilities.forms2.leaf">
	
	<cffunction name="setChecked">
		<cfargument name="checked">
		<cfset variables.forminfo.checked = arguments.checked>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfset addClassToWrapper("formitem_checkbox")>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"wrapperclasses")>
			<cfset lcl.wrapclasses = structkeylist(variables.forminfo.wrapperclasses, " ")>
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
		<cfset lcl.required = structkeyexists(variables.forminfo, 'required')>
		<!--- <cfset lcl.validationerror = variables.vdtr.hasError(variables.forminfo.name)> --->
		
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<div class="formitem<cfif structkeyexists(lcl, "wrapclasses")> #lcl.wrapclasses#</cfif>">
			<input <cfif structkeyexists(lcl, "formclasses")>class="#lcl.formclasses#"</cfif>
				type="checkbox" 
				name="#variables.forminfo.name#" 
				id="#lcl.id#"
				value="#variables.forminfo.default#"
				<cfif (structkeyexists(variables.formdata, variables.forminfo.name) AND variables.formdata[variables.forminfo.name] EQ variables.forminfo.default)
						OR (structkeyexists(variables.forminfo, "checked") AND variables.forminfo.checked)>checked</cfif>
                <cfif structkeyexists(lcl, "formclasses")>class="#lcl.formclasses#"</cfif> 
				<cfif structkeyexists(lcl, "formstyles")>style="#lcl.formstyles#"</cfif>>
			<label for="#lcl.id#">
				#variables.forminfo.label#
			</label>
			</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>

</cfcomponent>