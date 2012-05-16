<cfcomponent name="container" extends="utilities.forms2.container">
	
	<cffunction name="showhtml">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
		</cfif>
		
        <cfif structkeyexists(variables.forminfo,"styles")>
			<cfset lcl.styles = "">
            <cfloop collection="#variables.forminfo.styles#" item="lcl.itm">
                <cfset lcl.styles = lcl.styles & lcl.itm & ':' & variables.forminfo.styles[lcl.itm] & ';'>
            </cfloop>
		</cfif>
        
		<cfif structkeyexists(variables.forminfo,"classes")>
			<cfset lcl.classes = structkeylist(variables.forminfo.classes, " ")>
		</cfif>
        
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<div id="#lcl.id#" <cfif structkeyexists(lcl, "styles")>style="#lcl.styles#"</cfif> 
             <cfif structkeyexists(variables.forminfo, "classes")>class="#lcl.classes#"</cfif>>
			<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
				#variables.items[lcl.i].showHTML()#
			</cfloop>			
			</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>

</cfcomponent>