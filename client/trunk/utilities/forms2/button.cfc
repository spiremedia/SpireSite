<cfcomponent name="container" extends="utilities.forms2.container">
	
	<cffunction name="setType">
		<cfargument name="type" required="true">
		<cfset variables.forminfo.type = arguments.type>
	</cffunction>
	
	<cffunction name="setValue">
		<cfargument name="val" required="true">
		<cfset variables.forminfo.default = arguments.val>
	</cffunction>
	
	<cffunction name="showhtml">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"type")>
			<cfset lcl.type = variables.forminfo.type>
		<cfelse>
			<cfset lcl.type = "button">
		</cfif>

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
        
		<cfif structkeyexists(variables.forminfo,"classes")>
			<cfset lcl.classes = structkeylist(variables.forminfo.classes, " ")>
		</cfif>
        
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<button type="#lcl.type#" name="#variables.forminfo.name#" id="#lcl.id#" value="#iif(structkeyexists(variables.forminfo, "default"), "variables.forminfo.default", DE(""))#" <cfif structkeyexists(lcl, "styles")>style="#lcl.styles#"</cfif> 
             <cfif structkeyexists(variables.forminfo, "classes")>class="#lcl.classes#"</cfif>>
				<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
					#variables.items[lcl.i].showHTML()#
				</cfloop>			
			</button>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>

</cfcomponent>