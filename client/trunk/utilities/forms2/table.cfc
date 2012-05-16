<cfcomponent name="container" extends="utilities.forms2.container">
		
	<cffunction name="setname">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.name = name>
	</cffunction>
		
	<cffunction name="validate">
		<cfargument name="vdtr" required="true">
		
		<cfset lcl = structnew()>
		
		<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
			<cfset variables.items[lcl.i].validate(vdtr)>
		</cfloop>		
	</cffunction>
	
	<cffunction name="showhtml">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"classes")>
			<cfset lcl.classes = structkeylist(variables.forminfo.classes, " ")>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"styles")>
			<cfset lcl.formstyles = "">
			<cfloop collection="#variables.forminfo.styles#" item="lcl.itm">
				<cfset lcl.styles = lcl.styles & lcl.itm & ':' & variables.forminfo.styles[lcl.itm] & ';'>
			</cfloop>
		</cfif>
		
		<cfif structkeyexists(variables.forminfo,"attributes")>
			<cfset lcl.attributes = "">
			<cfloop collection="#variables.forminfo.attributes#" item="lcl.itm">
				<cfset lcl.attributes = lcl.attributes & ' ' & lcl.itm & '="' & variables.forminfo.attributes[lcl.itm] & """">
			</cfloop>
		</cfif>
		
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<table <cfif structkeyexists(lcl, "attributes")>#lcl.attributes#</cfif> class="formtable<cfif structkeyexists(variables.forminfo, "classes")> #lcl.classes#</cfif>"
            <cfif structkeyexists(variables.forminfo, "styles")>style="#lcl.styles#"</cfif>>
			<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
				#variables.items[lcl.i].showHTML()#
			</cfloop>			
			</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>

</cfcomponent>