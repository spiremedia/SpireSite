<cfcomponent name="form2text" extends="utilities.forms2.leaf">
	
	<cffunction name="firstOption">
		<cfargument name="label" required="true">
		<cfargument name="value" default="">
		<cfset variables.forminfo.firstoption = structnew()>
		<cfset variables.forminfo.firstoption.label = arguments.label>
		<cfset variables.forminfo.firstoption.value = arguments.value>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
		<cfset lcl.required = structkeyexists(variables.forminfo, 'required')>
		<!--- <cfset lcl.validationerror = variables.vdtr.hasError(variables.forminfo.name)> --->
		
		<cfif structkeyexists(variables.formdata, variables.forminfo.name)>
			<cfset lcl.thisval = variables.formdata[variables.forminfo.name]>
		<cfelseif structkeyexists(variables.forminfo, 'default')>
			<cfset lcl.thisval = variables.forminfo.default>
		<cfelse>
			<cfset lcl.thisval = "">
		</cfif>
		
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
			<select  <cfif structkeyexists(lcl, "formclasses")>class="#lcl.formclasses#"</cfif> <cfif structkeyexists(lcl, "formstyles")>style="#lcl.formstyles#"</cfif>
				name="#variables.forminfo.name#" 
					id="#lcl.id#">
				<cfif structkeyexists(variables.forminfo, "firstoption")>
					<option value="#variables.forminfo.firstoption.value#">#variables.forminfo.firstoption.label#</option>
				</cfif>
				<cfif structkeyexists(variables.forminfo, "data")>
					<cfif isdefined("variables.forminfo.data.list")>
						#listtooptions(lcl.thisval)#
					<cfelseif isdefined("variables.forminfo.data.query")>
						#querytooptions(lcl.thisval)#
					<cfelseif isdefined("variables.forminfo.data.array")>
						#arraytooptions(lcl.thisval)#
					</cfif>
				</cfif>
			</select>
			<cfif structkeyexists(variables.forminfo,"footertext")>
				<div class="footertext">#variables.forminfo.footertext#</div>
			</cfif>
			</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>

	<cffunction name="listtooptions">
		<cfargument name="thisval" required="true">
		<cfset var litm = "">
		<cfset var val = "">
		
		<cfoutput>
		<cfloop list="#variables.forminfo.data.list#" index="litm">
			<option <cfif thisval EQ litm>selected</cfif> value="#litm#">#litm#</option></cfloop>
		</cfoutput>
	</cffunction>
	
	<cffunction name="querytooptions">
		<cfargument name="thisval" required="true">
		<cfset var litm = "">
		<cfset var val = "">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo.data, "valuesfield")>
			<cfset lcl.valuesfield = variables.forminfo.data.valuesfield>
		<cfelse>
			<cfset lcl.valuesfield = "value">
		</cfif>
		
		<cfif structkeyexists(variables.forminfo.data, "labelsfield")>
			<cfset lcl.labelsfield = variables.forminfo.data.labelsfield>
		<cfelse>
			<cfset lcl.labelsfield = "label">
		</cfif>
	
		<cfoutput query="variables.forminfo.data.query">
			<option <cfif thisval EQ variables.forminfo.data.query[lcl.valuesfield][variables.forminfo.data.query.currentrow]>selected</cfif> value="#variables.forminfo.data.query[lcl.valuesfield][variables.forminfo.data.query.currentrow]#">#variables.forminfo.data.query[lcl.labelsfield][variables.forminfo.data.query.currentrow]#</option></cfoutput>
	</cffunction>
	
	<cffunction name="arraytooptions">
	
	</cffunction>
	
	<cffunction name="setData">
		<cfargument name="data">
		<cfset variables.forminfo.data = data>
	</cffunction>

</cfcomponent>