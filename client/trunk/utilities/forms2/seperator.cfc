<cfcomponent name="form2submit" extends="utilities.forms2.leaf">
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
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
				<hr <cfif isdefined("lcl.formclasses")>class="#lcl.formclasses#"</cfif><cfif structkeyexists(lcl, "formstyles")> style="#lcl.formstyles#"</cfif>/>
			</cfoutput>
		</cfsavecontent>

		<cfreturn lcl.h>
	</cffunction>
	
</cfcomponent>