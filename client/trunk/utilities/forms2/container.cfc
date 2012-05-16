<cfcomponent name="container" extends="utilities.forms2">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.items = arraynew(1)>
		<cfset variables.forminfo = structnew()>
		<cfset variables.formdata = structnew()>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="setid">
		<cfargument name="id" required="true">
		<cfset variables.forminfo.id = id>
	</cffunction>
	
	<cffunction name="setname">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.name = name>
	</cffunction>
	
	<cffunction name="setlabel">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.label = name>
	</cffunction>
		
	<cffunction name="validate">
		<cfargument name="vdtr" required="true">
		
		<cfset lcl = structnew()>
		
		<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
			<cfif structkeyexists(variables.items[lcl.i], "validate")>
				<cfset variables.items[lcl.i].validate(vdtr)>
			</cfif>
		</cfloop>		
	</cffunction>
	
	<cffunction name="addClass">
		<cfargument name="name" required="true">
		<cfparam name="variables.forminfo.classes" default="#structnew()#">
		<cfset variables.forminfo.classes[name] = 1>
	</cffunction>
	
    <cffunction name="addAttribute">
		<cfargument name="name" required="true">
        <cfargument name="value" required="true">
		<cfparam name="variables.forminfo.attributes" default="#structnew()#">
		<cfset variables.forminfo.attributes[name] = value>
	</cffunction>
    
	<cffunction name="setstyle">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">
		<cfparam name="variables.forminfo.styles" default="#structnew()#">
		<cfset variables.forminfo.styles[name] = value>
	</cffunction>
	
	<cffunction name="showhtml">
		<cfthrow message="extendme">
	</cffunction>

	<cffunction name="dump">
		<cfargument name="path">
		<cfset var lcl = structnew()>
		<cfset lcl.mtdt = getMetaData(this)>
		<cfoutput>
		<cfsavecontent variable="lcl.h">
			<fieldset class="container">
			<legend>container : #lcl.mtdt.name# : #listappend(path, variables.forminfo.name, ".")#</legend>
			<cfloop collection="#variables.forminfo#" item="lcl.itm">
				<cfif isstruct(variables.forminfo[lcl.itm])>
					<cfloop collection="#variables.forminfo[lcl.itm]#" item="lcl.itm2">
					#lcl.itm# .#lcl.itm2# : #variables.forminfo[lcl.itm][lcl.itm2]#<br></cfloop>
				<cfelseif issimplevalue(variables.forminfo[lcl.itm])>
					#lcl.itm# : #variables.forminfo[lcl.itm]#<br>
				<cfelse>
					#lcl.itm# : unknown type?
				</cfif>
			</cfloop>
			<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
				<cfif structkeyexists(variables.items[lcl.i], "dump")>
					#variables.items[lcl.i].dump(listappend(path, variables.forminfo.name,"."))#
				<cfelse>
					<cfset lcl.lclmtdt = getMetaData(variables.items[lcl.i])>
					#lcl.lclmtdt.name#
				</cfif>
			</cfloop>
			</fieldset>
		</cfsavecontent>
		</cfoutput>
		<cfreturn lcl.h>
	</cffunction>
	
</cfcomponent>