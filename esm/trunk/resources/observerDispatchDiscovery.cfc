<cfcomponent name="modules">
		<!--- 
			this cfc loops thru all the top level folders and finds cfcs that are called observers.cfc.  
			Then it captures all the method names from those cfcs and puts them in a json serialized object
			in the file /cache/observers.cfm for future use
		 --->
	<cffunction name="init">
		
		<cfargument name="settings" required="true">
		<cfset var filepath = settings.getVar("machineRoot") & '/'>
		<cfset var dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(filepath)>
		<cfset var modules = structnew()>
		<cfset var lcl = structnew()>
		
		<cfset variables.observersfilepath = settings.getVar("machineRoot") & "/cache/observers.cfm">
		<cfset variables.observers = structnew()>
		
		<cfloop query="dirs">
			<cfif fileexists(filepath & name & "/observers.cfc")>
				<cfset lcl.thisobserver = createobject("component", "#name#.observers")>
				<cfset lcl.observerinfo = getMetaData(lcl.thisobserver)>
				<cfset addObserver(lcl.observerinfo)>
			</cfif>
		</cfloop>
		<cfset writeobservers()>
	</cffunction>
	
	<cffunction name="addObserver">
		<cfargument name="observerinfo" required="true">
		<cfset var pathname = observerinfo.name>
		<cfset var filepath = observerinfo.path>
		<cfset var tmp = structnew()>
		<cfloop from="1" to="#arraylen(observerinfo.functions)#" index="i">
			<cfset item = observerinfo.functions[i]>
			<cfif item.name NEQ 'init'>
				<cfif NOT structkeyexists(variables.observers, item.name)>
					<cfset variables.observers[item.name] = arraynew(1)>
				</cfif>
				<cfset arrayappend(variables.observers[item.name], pathname)>
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="writeObservers">
		<cfset var obs = serializejson(variables.observers)>
		<cffile action="write" file="#variables.observersfilepath#" output="#obs#">
	</cffunction>
</cfcomponent>