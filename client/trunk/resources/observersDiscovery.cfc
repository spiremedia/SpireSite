<cfcomponent name="modules">

	<cffunction name="init">
		<cfargument name="settings" required="true">
		<cfset var filepath = settings.getVar("machineRoot") & '/modules/'>
		<cfset var dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(filepath)>
		<cfset var modules = structnew()>
		<cfset var lcl = structnew()>
		
		<cfset variables.observersfilepath = settings.getVar("machineRoot") & "/cache/observers/observers.cfm">
		<cfset variables.observers = structnew()>

		<cfloop query="dirs">
			<cfif fileexists(filepath & dirs.name & "/observers.cfc")>
				<cfset addObserver(dirs.name, dirs.currentrow)>
			</cfif>
		</cfloop>
		
		<cfset writeobservers()>
	</cffunction>
	
	<cffunction name="addObserver">
		<cfargument name="name" required="true">
		<cfargument name="cnt" required="true">
		
		<cfset var lcl = structnew()>

		<cfset lcl.thisobserver = createobject("component", "modules.#name#.observers")>
	
		<cfset lcl.observerinfo = getMetaData(lcl.thisobserver)>
		
		<cfif NOT structkeyexists(lcl.observerinfo, "functions")>
			<cfreturn>
		</cfif>

		<cfset lcl.pathname = lcl.observerinfo.name>
		<cfset lcl.filepath = lcl.observerinfo.path>

			<cfloop from="1" to="#arraylen(lcl.observerinfo.functions)#" index="lcl.i">
				<cfset lcl.tosave = structnew()>
				<cfset lcl.method = lcl.observerinfo.functions[lcl.i]>
				<cfif lcl.method.name EQ "init">
					<cfcontinue>
				</cfif>
				<cfif isdefined("lcl.thisobserver.executeorder_" & lcl.method.name)>
					<cfset lcl.tosave.executeorder = lcl.thisobserver["executeorder_" & lcl.method.name]>
				<cfelse>
					<cfset lcl.tosave.executeorder = 10>
				</cfif>
				
				<cfset lcl.tosave.pathname = lcl.pathname>
				
				<cfif NOT structkeyexists(variables.observers, lcl.method.name)>
					<cfset variables.observers[lcl.method.name] = structnew()>
				</cfif>
				
				<cfset variables.observers[lcl.method.name][lcl.pathname] = lcl.tosave>
			</cfloop>
			<!--- <cfcatch>
				error dealing with observer 
				<cfdump var=#arguments.observerinfo#>
				<cfdump var=#lcl.observerinfo#>
				<cfdump var=#cfcatch#>
				<cfabort>
			</cfcatch>
		</cftry> --->

	</cffunction>
	
	<cffunction name="writeObservers">
		<cfset var lcl = structnew()>
		
		<cfset lcl.allobservers = structnew()>
		
		<cfloop collection="#variables.observers#" item="lcl.obsidx">
			<cfset lcl.sorted = structsort(variables.observers[lcl.obsidx], "numeric", "asc", "executeorder")>
			<cfset lcl.allobservers[lcl.obsidx] = lcl.sorted>
		</cfloop>

		<cfset obs = serializejson(lcl.allobservers)>

		<cffile action="write" file="#variables.observersfilepath#" output="#obs#">
	</cffunction>
</cfcomponent>