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
		
		<cfsavecontent variable="lcl.h">
			<cfoutput>
			<div class="formsubsection">
			<cfif structkeyexists(variables.forminfo,"label")>
				<div class="sectionlabel">#variables.forminfo.label#</div>
			</cfif>
			<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
				#variables.items[lcl.i].showHTML()#
			</cfloop>			
			</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn lcl.h>
	</cffunction>
	
	
</cfcomponent>