<cfcomponent name="abstract module controller">
	
	<cffunction name="init">
		<cfargument name="title" required="true">
		<cfargument name="data" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="pageRef" required="true">
		<cfargument name="name" required="true">
		
		<cfset variables.title = arguments.title>
		<cfset variables.data = arguments.data>
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.pageRef = arguments.pageRef>
		<cfset variables.name = arguments.name>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfargument name="module" required="true">
		<cfargument name="moduleaction" default="default">

		<cfset var html = "">
		<cfset var rhtml = "">
		<cfset var lcl = structnew()>

		<cfif NOT fileexists(requestObject.getVar("machineroot") & "/modules/" & module & '/templates/' & moduleaction & ".cfm")>
			<cfthrow message="show html not overridden. expecting a file named '#module & '/templates/' & moduleaction & ".cfm (ac)"#'">
		</cfif>
		
		<cfsavecontent variable="rhtml">
			<cfinclude template="../modules/#module#/templates/#moduleaction#.cfm">
		</cfsavecontent>
		
		<cfif structkeyexists(variables, "useparseforlanguage")>
			<cfset rhtml = parseforlanguage(rhtml)>
		</cfif>
		
		<cfset html = trim(rhtml)>
		
		<cfif isdefined("variables.title") AND variables.title NEQ "">
			<cfset html = structnew()>
			<cfset html.title = variables.title>
			<cfset html.html = rhtml>
		<cfelse>
			<cfset html = rhtml>
		</cfif>
		
		<cfreturn html>
	</cffunction>
		
	<cffunction name="getResource">
		<cfargument name="name" required="true">
		<cfset var rs = createObject('component', 'resources.#name#')>
		<cfreturn rs>
	</cffunction>
    
	<cffunction name="getUtility">
		<cfargument name="name" required="true">
		<cfset ut = createObject('component', 'utilities.#name#')>
		
		<cfreturn ut>
	</cffunction>
    
    <cffunction name="parseForLanguage">
		<cfargument name="content" required="true">
    	<cfset var item = structnew()>
        <cfset var state = requestObject.getStateObject()>
        <cfset var linkre = '\{\{link\[([A-Z0-9\-]{35})\]\[([A-Z0-9\-]{35})\]\}\}'>
        <cfset var assetre = '\{\{asset\[([A-Z0-9\-]{35})\]\}\}'>
    	<cfset var reobj = "">
        <cfset var timestamp = now() + 0>
        
        <!--- replace all the links --->
        <cfset reobj = refind(linkre, arguments.content, 0, true)>

       	<cfloop condition="reobj.len[1] NEQ 0">
        	<cfset item.siteid = mid(arguments.content, reobj.pos[2], reobj.len[2])>
        	<cfset item.pageid = mid(arguments.content, reobj.pos[3], reobj.len[3])>
	
			<!--- <cfset item.path = state.pathTranslator(item.siteid, item.pageid)> --->
			<cfset item.path = state.linkPathTranslator(item.siteid, item.pageid, requestObject)>
			
            <cfset arguments.content = left(arguments.content, reobj.pos[1] -1)
					& item.path 
                    & right(arguments.content, len(arguments.content) - reobj.pos[1] - reobj.len[1] +1)>
			<cfset reobj = refind(linkre, arguments.content,0, true)>
        </cfloop>
     
        <!--- replace all the assets --->
        <cfset reobj = refind(assetre, arguments.content, 0, true)>

       	<cfloop condition="reobj.len[1] NEQ 0">
        	<cfset item.assetid = mid(arguments.content, reobj.pos[2], reobj.len[2])>
	
			<cfset item.path = state.assetPathTranslator(item.assetid, requestObject)>
			
            <cfset arguments.content = left(arguments.content, reobj.pos[1] -1)
					& item.path 
                    & right(arguments.content, len(arguments.content) - reobj.pos[1] - reobj.len[1] +1)>
			<cfset reobj = refind(assetre, arguments.content,0, true)>
        </cfloop>

		<cfreturn arguments.content>
	</cffunction>
    
	<cffunction name="notEmpty">
		<cfreturn true>
	</cffunction>
    
	<cffunction name="getCacheLength">
		<cfreturn 20>
	</cffunction>
	
	<cffunction name="onmissingmethod" output="false">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments"> 

		<!--- methods may be auto plumbed to either an include in templates or to a subccontroller. If so, arguments will have action and module fields--->
		<cfif isstruct(missingmethodarguments) AND structkeyexists(missingMethodArguments, "moduleaction") AND structkeyexists(missingMethodArguments, "module")>	
		<!--- check if there is a subcontroller. If so autodelegate it --->
			<cfif fileexists(variables.requestObject.getVar("machineroot") & "/modules/" & missingmethodarguments.module & "/" & missingmethodarguments.moduleaction & "ctrl.cfc")>
				<cfreturn createObject("component", "modules.#missingmethodarguments.module#.#missingmethodarguments.moduleaction#ctrl").init(
								data = variables.data, 
									requestObject = variables.requestObject, 
										pageRef = variables.pageref, 
											name = variables.name, 
												title = variables.title,
													module = missingmethodarguments.module, 
														moduleaction = missingmethodarguments.moduleaction
				)>
			</cfif>
				
			<!--- check if an include with action name exists auto. also load a model if found --->
			<cfif  missingMethodName EQ "default" OR fileexists(variables.requestObject.getVar("machineroot") & "/modules/" & missingmethodarguments.module & "/templates/" & missingmethodarguments.moduleaction & ".cfm") OR structkeyexists(variables, "showhtml")>
				<cfif fileexists(requestObject.getVar("machineroot") & '/modules/' & missingmethodarguments.module & '/models/' & missingmethodarguments.module & ".cfc")>
					<cfset variables[missingmethodarguments.module & "Model"] = createObject("component", "modules.#missingmethodarguments.module#.models.#missingmethodarguments.module#").init(requestObject = requestObject)>
				</cfif>
				<cfreturn this>
			</cfif>
		</cfif>
		
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