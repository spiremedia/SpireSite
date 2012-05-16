<cfcomponent name="form2submit" extends="utilities.forms2.leaf">
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo,"id")>
			<cfset lcl.id = variables.forminfo.id>
		<cfelse>
			<cfset lcl.id = variables.forminfo.name>
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
        
        <cfif structkeyexists(variables.forminfo,"styles")>
			<cfset lcl.styles = "">
            <cfloop collection="#variables.forminfo.styles#" item="lcl.itm">
                <cfset lcl.styles = lcl.styles & lcl.itm & ':' & variables.forminfo.styles[lcl.itm] & ';'>
            </cfloop>
		</cfif>
        
		<cfsavecontent variable="lcl.h">
			<cfoutput>
            <cfif structkeyexists(lcl, "wrapclasses")><div class="formitem #lcl.wrapclasses#"></cfif>
			<img 
                class="img"
                    src="#variables.forminfo.source#"
                        id="#lcl.id#"
                            <cfif structkeyexists(lcl, "formclasses")>class="#lcl.formclasses#"</cfif> 
                                <cfif structkeyexists(lcl, "formstyles")>style="#lcl.formstyles#"</cfif>>
           <cfif structkeyexists(lcl, "wrapclasses")></div></cfif>
			</cfoutput>
		</cfsavecontent>

		<cfreturn lcl.h>
	</cffunction>
	
    <cffunction name="setSource">
    	<cfargument name="source" required="yes">
        <cfset variables.forminfo.source =  arguments.source>        
    </cffunction>
    
</cfcomponent>