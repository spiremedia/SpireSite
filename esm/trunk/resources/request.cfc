<cfcomponent name="request" extends="resources.registry" output="false">

	<cffunction name="init">
		<cfset var itm = "">
		<cfset variables.requestvars = url>
		<cfset structappend(variables.requestvars, form)>
		<cfloop collection="#variables.requestvars#" item="itm">
			<cfset variables.requestvars[itm] = trim(variables.requestvars[itm])>
		</cfloop>
		<cfset variables.v = structnew()>
		<cfset variables.requestlog = structnew()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModuleFromPath" output="false">
		<cfif structkeyexists(variables.requestvars,'module')>
			<cfreturn variables.requestvars.module>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>
	
	<cffunction name="getActionFromPath">

		<cfif structkeyexists(variables.requestvars,'action')>
			<cfreturn variables.requestvars.action>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>
	
	<cffunction name="getMachineRoot">
		<cfreturn GetDirectoryFromPath(GetCurrentTemplatePath())>
	</cffunction>

	<cffunction name="isformurlvarset">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.requestvars, arguments.name)>
	</cffunction>
	
	<cffunction name="getformurlvar" output="false">
		<cfargument name="name" required="true">
		<cfargument name="default">
		
		<cfif NOT structkeyexists(variables.requestvars, arguments.name)>
			<cfif structkeyexists(arguments, "default")>
				<cfreturn arguments.default>
			</cfif>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn variables.requestvars[arguments.name]>
	</cffunction>
	
	<cffunction name="getallformurlvars">
		<cfreturn duplicate(variables.requestvars)>
	</cffunction>
	
	<!--- <cffunction name="notifyObservers">
		<cfargument name="label" required="true">
		<cfargument name="observed" required="true">
		<cfargument name="hint" default="">
		
		<cfset var ret = arraynew(1)>
		<cfset var lcl = structnew()>
		<cfset var itemobserved = arguments.observed>
		
		<cfset variables.logmsg("observed events", "<b>#label#</b> (used : #hasObservers(label)#)<br>#hint#")>
		
		<cfset arguments.label = replace(arguments.label, ".","_")>
		
		<cfif NOT structkeyexists(variables, "observers")>
			<cfset variables.observers = createobject("component", "resources.observerDispatch").init(this)>	
		</cfif>
	
		<cfset lcl.objects = variables.observers.getObserversForLabel(arguments.label)>
		
		<cfloop from="1" to="#arraylen(lcl.objects)#" index="lcl.i"><!--- collection="#lcl.objects#" item="lcl.item"> --->
			<cftry>
				<cfset lcl.thisobj = createObject("component", lcl.objects[lcl.i]).init(this)><!--- lcl.objects[lcl.i]getObj(lcl.item.name)>--->
				<cfinvoke method="#label#" returnvariable="itemobserved" component="#lcl.thisobj#">
					<cfinvokeargument name="observed" value="#itemobserved#">
				</cfinvoke>

				<cfcatch>
					<cfoutput>ERROR while processsing observer with label "#label#" in #lcl.objects[lcl.i]#</cfoutput>
					<cfdump var=#cfcatch#>
					<cfabort>
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cfreturn itemobserved>
	</cffunction> --->
	
	<cffunction name="notifyObservers">
		<cfargument name="label" required="true">
		<cfargument name="observed" required="true">
		<cfargument name="mode" default="exact">
		
		<cfset var ret = arraynew(1)>
		<cfset var lcl = structnew()>
		<cfset var labels = listtoarray(arguments.label,".")>
		<cfset var labels2 = arraynew(1)>

		<!--- this loop converts the label with periods to each subobserver to notify. so, test.hi becomes [test_hi,test] so that each can be observed --->
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
		
			<!--- <cfset arrayappend(variables.observerhistory, {label = lcl.flabel, objects = lcl.objects})> --->
			<cfset variables.logmsg("observed events", "<b>#lcl.flabel#</b> (used : #hasObservers(lcl.flabel)#)")>
			
			<cfloop from="1" to="#arraylen(lcl.objects)#" index="lcl.i"><!---collection="#lcl.objects#" item="lcl.item">--->
				<cfset lcl.thisobj = createObject("component", lcl.objects[lcl.i]).init(this)><!---getObj(lcl.item.name)>--->
		
				<cfinvoke method="#lcl.flabel#" returnvariable="arguments.observed" component="#lcl.thisobj#">
					<cfinvokeargument name="observed" value="#arguments.observed#">
				</cfinvoke>
			</cfloop>
		</cfloop>

		<cfreturn arguments.observed>
	</cffunction>
	
	<cffunction name="hasObservers">
		<cfargument name="label" required="true">

		<cfset variables.logmsg("observer check", "check if <strong>#label#</strong> exists.")>
		
		<cfif NOT structkeyexists(variables, "observers")>
			<cfset variables.observers = createobject("component", "resources.observerDispatch").init(this)>	
		</cfif>
	
		<cfreturn variables.observers.hasObserversForLabel(arguments.label)>
	</cffunction>
	
	<cffunction name="logmsg">
		<cfargument name="type" required="true">
		<cfargument name="msg" required="true">
		<cfif NOT structkeyexists(variables.requestlog, type)>
			<cfset variables.requestlog[type] = arraynew(1)>
		</cfif>
		<cfset arrayappend(variables.requestlog[type], msg)>
	</cffunction>
	
	<cffunction name="getlog">
		<cfreturn variables.requestlog>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var m = structnew()>
		<cfset m.formurl = variables.requestvars>
		<cfset m.set = variables.v>
		<cfdump var="#m#">
	</cffunction>
	
</cfcomponent>