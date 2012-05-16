<cfcomponent name="abstract module controller" extends="resources.abstractController">
	<cffunction name="init">
		<cfargument name="data" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="pageRef" required="true">
		<cfargument name="name" required="true">
		<cfargument name="title" required="true">
		<cfargument name="module" required="true">
		<cfargument name="moduleaction" required="true">
		
		<cfset variables.data = arguments.data>
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.pageRef = arguments.pageRef>
		<cfset variables.name = arguments.name>
		<cfset variables.title = arguments.title>
		<cfset variables.module = arguments.module>
		<cfset variables.moduleaction = arguments.moduleaction>
		
		<cfif fileexists(requestObject.getVar("machineroot") & '/modules/' & arguments.module & '/models/' & arguments.module & ".cfc")>
			<cfset variables[module & "Model"] = createObject("component", "modules.#arguments.module#.models.#arguments.module#").init(requestObject = requestObject)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="onmissingmethod" output="false">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments"> 
		
		<cfif refindnocase("^get.+Model$", missingMethodName)>
			<cfif arraylen(missingMethodArguments) EQ 1 AND fileexists("#requestObject.getVar("machineroot") & "/modules/" & missingMethodArguments[1] & "/models/" & mid(missingMethodName, 4, len(missingMethodName) -8)#.cfc")>
				<cfreturn createObject("component", "modules.#missingMethodArguments[1]#.models.#mid(missingMethodName, 4, len(missingMethodName) -8)#").init(requestObject)>
			</cfif>

			<cfif arraylen(missingMethodArguments) EQ  0 AND isdefined("variables.module") AND fileexists("#requestObject.getVar("machineroot") & "/modules/" & variables.module & "/models/" & mid(missingMethodName, 4, len(missingMethodName) -8)#.cfc")>
				<cfreturn createObject("component", "modules.#variables.module#.models.#mid(missingMethodName, 4, len(missingMethodName) -8)#").init(requestObject)>
			</cfif>
		</cfif>
		
		<cfthrow message="method #missingmethodname# does not exist">
	</cffunction>
	
</cfcomponent>