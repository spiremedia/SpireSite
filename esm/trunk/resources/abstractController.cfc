<cfcomponent name="parent controller">
	<cffunction name="getResource">
		<cfargument name="name" required="true">
		<cftry>
			<cfreturn createObject('component','resources.#arguments.name#').init(arguments)>
			<cfcatch>
				<cfthrow message="Could not find resource #arguments.name#">
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getwidget">
		<cfargument name="name" required="true">
		<cftry>
			<cfreturn createObject('component','widgets.#arguments.name#').init(arguments)>
			<cfcatch>
				<cfthrow message="Could not find widget #arguments.name#">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getUtility">
		<cfargument name="name" required="true">
		<cftry>
			<cfreturn createObject('component','utilities.#arguments.name#')>
			<cfcatch>
				<cfthrow message="Could not find util #arguments.name#">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="onmissingmethod">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments" type="struct"> 
		<cfset var label = "controllermethod_#missingmethodArguments.requestObject.getModuleFromPath()#_#missingmethodname#">
		<cfif missingmethodArguments.requestObject.hasObservers(label)>
			<cfset missingmethodArguments.requestObject.notifyObservers(label, missingMethodArguments.displayObject, "missing controller method")>
			<cfreturn>
		</cfif>
		
		<cfthrow message="#missingmethodname# was not found in controller.">
	</cffunction>
</cfcomponent>