<cfcomponent name="observermanager" output="false">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfset var lcl = structnew()>
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.observers = structnew()>
		
		<cfif fileexists(requestObj.getVar("machineroot") & "/cache/observers.cfm")>
			<cffile action="read" file="#requestObj.getVar("machineroot") & "cache/observers.cfm"#" variable="lcl.observers">
			<cfset variables.observers = deserializejson(lcl.observers)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getObserversForLabel">
		<cfargument name="label" required="true">
		
		<cfif structkeyexists(variables.observers, arguments.label)>
			<cfreturn variables.observers[arguments.label]>
		</cfif>
		
		<cfreturn arraynew(1)>
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