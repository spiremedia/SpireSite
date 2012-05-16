<cfcomponent name="esmmoduleinstaller">
	<cffunction name="init">
    	<cfset itms = arraynew(1)>
		<cfset variables.wrapstart = "<ul>">
		<cfset variables.wrapend = "</ul>">
		<cfset variables.itemstart = "<li>">
		<cfset variables.itemend = "</li>">
		<cfset variables.del = chr(13) & chr(10)>
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="note">
    	<cfargument name="noteitem" required="true">
        <cfset arrayappend(itms, noteitem)>
    </cffunction>
	
	<cffunction name="count">
        <cfreturn arraylen(itms)>
    </cffunction>
    
    <cffunction name="show">
    	<cfset itmcntr = "">
    	<cfloop from="1" to="#arraylen(itms)#" index="itmcntr">
        	<cfset itms[itmcntr] = variables.itemstart & itms[itmcntr] & variables.itemend>
        </cfloop>
        <cfif arraylen(itms)>
    		<cfset s = variables.wrapstart & arraytolist(itms, variables.del) & variables.wrapend>
			<cfset itms = arraynew(1)>
			<cfreturn s>
        <cfelse>
        	<cfreturn "">
        </cfif>
    </cffunction>
	
	<cffunction name="setwrap">
		<cfargument name="start">
		<cfargument name="end">
		<cfset variables.wrapstart = start>
		<cfset variables.wrapend = end>
	</cffunction>
	
	<cffunction name="setitemwrap">
		<cfargument name="start">
		<cfargument name="end">
		<cfset variables.itemstart = start>
		<cfset variables.itemend = end>
	</cffunction>
	
	<cffunction name="setdel">
		<cfargument name="del">
		<cfset variables.del = arguments.del>
	</cffunction>

	<cffunction name="dump">
		<cfdump var=#variables#>
		<cfabort>
	</cffunction>
</cfcomponent>