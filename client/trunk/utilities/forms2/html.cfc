<cfcomponent name="form2text" extends="utilities.forms2.leaf">
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			#variables.forminfo.html#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>
	
	<cffunction name="setHTML">	
		<cfargument name="html" required="true">
		<cfset variables.forminfo.html = html>
	</cffunction>
	
</cfcomponent>