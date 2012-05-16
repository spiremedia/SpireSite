<cfcomponent name="observermanager" output="false">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset var lcl = structnew()>
		<cfset variables.observers = structnew()>
		<cfif fileexists(requestObject.getVar("machineroot") & "/cache/observers/observers.cfm")>
			<cffile action="read" file="#requestObject.getVar("machineroot") & "/cache/observers/observers.cfm"#" variable="lcl.observers">
			<cfset variables.observers = deserializejson(lcl.observers)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getObserversForLabel">
		<cfargument name="label" required="true">
		<cfargument name="match" required="true">
		<cfset var lcl = structnew()>

		<!--- <cfif match EQ "exact"> --->
			<cfif structkeyexists(variables.observers, arguments.label)>
				<cfreturn variables.observers[arguments.label]>
			</cfif>
			<cfreturn arraynew(1)>
		<!--- <cfelse>
			<cfset lcl.matches = arraynew(1)>
			<cfloop collection="#variables.observers#" item="lcl.itm">
				<cfif left(lcl.itm, len(label)) EQ label>
					
				</cfif>
			</cfloop>
		</cfif> --->
	</cffunction>
	
	<cffunction name="hasObserversForLabel">
		<cfargument name="label" required="true">
		<cfreturn structkeyexists(variables.observers, arguments.label)>
	</cffunction>
		
	<cffunction name="dump">
		<cfargument name="label" default="all">
		<cfif arguments.label EQ "all">
			<cfdump var=#variables.observers#>	
		<cfelse>
			<cfdump var=#variables.observers[arguments.label]#>	
		</cfif>
	</cffunction>
</cfcomponent>