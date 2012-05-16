<cfcomponent name="request" output="false"><!--- extends registry? --->
	
	<cffunction name="init" output="false">
		<cfset variables.requestvars = duplicate(cookie)>
		<cfset variables.observerhistory = arraynew(1)>
		<cfset structappend(variables.requestvars, url)>
		<cfset structappend(variables.requestvars, form)>
	
		<!-- remove first slashes on path -->
		<cfif isdefined("variables.requestvars.path")>
			<cfset variables.requestvars.path = rereplace(variables.requestvars.path,'^/+','')>
			<cfif not refind('/$', variables.requestvars.path)>
				<cfset variables.requestvars.path = variables.requestvars.path & '/'>
			</cfif>
		</cfif>
	
		<cfset variables.v = structnew()>
		<cfset variables.v.requestTimeStamp = now() + 0>
		<cfset variables.savedobservers = structnew()>
		<cfset variables.rr = structnew()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setvar" output="false">
		<cfargument name="name">
		<cfargument name="value">
	
		<cfif structkeyexists(variables.v, name)>
			<cfthrow message="'#name#' already exists in request">
		</cfif>
	
		<cfset variables.v[name] = value>
	</cffunction>
	
	<cffunction name="setRequestRegistryVar" output="false">
		<cfargument name="name">
		<cfargument name="value">
	
		<cfif structkeyexists(variables.rr, name)>
			<cfthrow message="'#name#' already exists in request">
		</cfif>
	
		<cfset variables.rr[name] = value>
	</cffunction>
	
	<cffunction name="getvar" output="false">
		<cfargument name="name" required="true">
		<cfargument name="dflt">
		<cfif not structkeyexists(variables.v, name)>
			<cfif  structkeyexists(arguments, 'dflt')>
				<cfreturn dflt>
			</cfif>
			<cfthrow message="'#name#' not set in request">
		</cfif>
	
		<cfreturn variables.v[name]>
	</cffunction>
	
	<cffunction name="isvarset" output="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.v, name)>
	</cffunction>
	
	<cffunction name="isformurlvarset" output="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.requestvars, arguments.name)>
	</cffunction>
	
	<cffunction name="isRequestRegistryVarSet" output="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.rr, arguments.name)>
	</cffunction>
	
	<cffunction name="getformurlvar" output="false">
		<cfargument name="name" required="true">
		<cfargument name="dflt">
		<cfif NOT structkeyexists(variables.requestvars, arguments.name)>
			<cfif  structkeyexists(arguments, 'dflt')>
				<cfreturn dflt>
			</cfif>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn htmleditformat(variables.requestvars[arguments.name])>
	</cffunction>
	
	<cffunction name="getunsafeformurlvar" output="false">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.requestvars, arguments.name)>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn variables.requestvars[arguments.name]>
	</cffunction>
	
	<cffunction name="getallformurlvars" output="false">
		<cfset var dupvars = duplicate(variables.requestvars)>
		<cfset var idx = "">
		<!--- its possible to set a cookie to be null. This comes across as a null value which will break further processing. Remove any null values here. --->
		<cfloop collection="#dupvars#" item="idx">
			<cfif structkeyexists(dupvars,idx)>
				<cfset dupvars[idx] = htmleditformat(dupvars[idx])>
			<cfelse>
				<cfset structdelete(dupvars, idx)>
			</cfif>
		</cfloop>
		<cfreturn dupvars>
	</cffunction>
	
	<cffunction name="getRequestRegistryVar" output="false">
		<cfargument name="name">
	
		<cfif not structkeyexists(variables.rr, name)>
			<cfthrow message="'#name#' not set in request Registry">
		</cfif>
	
		<cfreturn variables.rr[name]>
	</cffunction>
	
	<cffunction name="getUrlIdentifyer">
		<!--- this regex removes url variables path, reset and refresh from the cgi.querystring --->
		<cfset var t = rereplacenocase(cgi.QUERY_STRING, "(path|&reset|&refresh)[^&]*","","all")>

		<!--- concat escaped path and remaining escaped url vars --->
		<cfset t = rereplace(getFormUrlVar('path'), "[^a-zA-Z0-9]", "_","all") & "-" & rereplace(t, "[^a-zA-Z0-9]", "_","all")>
		<!--- add marketing type to keep seperate caches --->
		<cfset t = t & '-' & session.user.getMemberType()>
	
		<cfreturn t>
	</cffunction>
	
	<cffunction name="getUserObject" output="false">
		<cfreturn session.user>	 
	</cffunction>
	
	<cffunction name="getStateObject" output="false">
		<cfreturn variables.stateObject>
	</cffunction>
	
	<cffunction name="setStateObject" output="false">
		<cfargument name="stateObject" required="true">
		<cfset variables.stateObject = arguments.stateObject>
	</cffunction>
	
	<cffunction name="clean">
		<cfargument name="txt" required="true">
		<cfargument name="mode" default="plain">
		<cfif mode EQ 'plain'>
			<cfset txt = rereplace(txt, '<[^>]+>', '', "all")>
		</cfif>
		<cfreturn txt>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var m = structnew()>
		<cfset m.requestvars = requestvars>
		<cfset m.setvars = v>
		dump in request
		<cfdump var=#m#>
		<cfabort>
	</cffunction>
	
	<cffunction name="notifyObservers">
		<cfargument name="label" required="true">
		<cfargument name="observed" required="true">
		<cfargument name="mode" default="exact">
		
		<cfset var ret = arraynew(1)>
		<cfset var lcl = structnew()>
		<cfset var labels = listtoarray(arguments.label,".")>
		<cfset var labels2 = arraynew(1)>

		<cfloop from="1" to="#arraylen(labels)#" index="lcl.j">
			<cfset labels2[lcl.j] = ''>
			<cfloop from="1" to="#lcl.j#" index="lcl.k">
				<cfset labels2[lcl.j] = listappend(labels2[lcl.j], labels[lcl.k], ".")>
			</cfloop>
		</cfloop>
	
		<cfloop array="#labels2#" index="lcl.label">
			<cfset lcl.flabel = replace(lcl.label, ".", "_", "all")>
			
			<cfif NOT structkeyexists(variables, "observers")>
				<cfset variables.observers = createobject("component", "resources.observerDispatch").init(this)>	
			</cfif>
		
			<cfset lcl.objects = variables.observers.getObserversForLabel(lcl.flabel, arguments.mode)>
		
			<cfset arrayappend(variables.observerhistory, {label = lcl.flabel, objects = lcl.objects})>
		
			<cfloop from="1" to="#arraylen(lcl.objects)#" index="lcl.i"><!---collection="#lcl.objects#" item="lcl.item">--->
				<cfset lcl.thisobserverpath = lcl.objects[lcl.i]>
				<cfif structkeyexists(variables.savedobservers, lcl.thisobserverpath)>
					<cfset lcl.thisobj = variables.savedobservers[lcl.thisobserverpath]>
				<cfelse>
					<cfset lcl.thisobj = createObject("component", lcl.thisobserverpath).init(this)><!---getObj(lcl.item.name)>--->
					<cfset variables.savedobservers[lcl.thisobserverpath] = lcl.thisobj>
				</cfif>
				
				<cfinvoke method="#lcl.flabel#" returnvariable="observed" component="#lcl.thisobj#">
					<cfinvokeargument name="observed" value="#observed#">
				</cfinvoke>
			</cfloop>
		</cfloop>

		<cfreturn observed>
	</cffunction>
	
	<cffunction name="getObserversOnLabel">
		<cfargument name="label" required="true">
	
		<cfset var lcl = structnew()>
	
		<cfset arguments.label = replace(arguments.label, ".","_")>
		
		<cfif NOT structkeyexists(variables, "observers")>
			<cfset variables.observers = createobject("component", "resources.observerDispatch").init(this)>	
		</cfif>
	
		<cfreturn variables.observers.getObserversForLabel(arguments.label, 'exact')>
	</cffunction>
		
	<cffunction name="getObserverHistory">
		<cfreturn variables.observerhistory>
	</cffunction>
	
	<cffunction name="log">
		<cfargument name="label" required="true">
		<cfargument name="message" required="true">
	
		<cfset var lcl = structnew()>
		
		<cfset lcl.logObj = createobject("component", this.getVar("logcfc","utilities.txtlog")).init(this)>	
		
		<cfset lcl.logObj.log(label, message)>
	</cffunction>
	
</cfcomponent>