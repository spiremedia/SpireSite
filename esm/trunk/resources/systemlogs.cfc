<cfcomponent name="systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setLogInfo">
		<cfargument name="json" required="true">
		<cfset variables.eventsinfo = deserializeJson(json)>
	</cffunction>
	
	<cffunction name="getLogModel" access="private">
		<cfif NOT structkeyexists(variables,"logModel")>
			<cfset variables.logModel = createObject("component","resources.activityLogsModel").init(requestObject, userObject)>
		</cfif>
		<cfreturn variables.logModel>
	</cffunction>
	
	<cffunction name="getRecentHistory">
		<cfargument name="limit" default="400">
		
		<cfset var lm = getLogModel()>
		<cfset var condtions = structnew()>
		
		<cfset conditions.sort = "activityLogs.created DESC">
		<cfset conditions.rowscount = arguments.limit>
		
		
		
		<cfreturn lm.getAll(conditions)>
	</cffunction>
	
	<cffunction name="getRecentModuleHistory">
		<cfargument name="moduleName" required="true">
		<cfargument name="limit" default="30">
		<cfargument name="tablename" required="no">
		
		<cfset var lm = getLogModel()>
		<cfset var condtions = structnew()>
		
		<cfset conditions.modulename = modulename>
		<cfset conditions.sort = "activityLogs.created DESC">
		<cfset conditions.rowscount = arguments.limit>
		<cfif structKeyExists(arguments, 'tablename')>
			<cfset conditions.tablename = tablename>
		</cfif>
		
		<cfif structkeyexists(variables.eventsinfo, "nositeid") AND variables.eventsinfo.nositeid>
			<cfset conditions.nositeid = true>
		</cfif>
		
		<cfreturn lm.getAll(conditions)>
	</cffunction>
	
	<cffunction name="getRecentModuleItemHistory">
		<cfargument name="moduleName" required="true">
		<cfargument name="itemid" required="true">
		
		<cfset var lm = getLogModel()>
		<cfset var condtions = structnew()>
		
		<cfset conditions.modulename = modulename>
		<cfset conditions.sort = "activityLogs.created DESC">
		<cfset conditions.itemid = arguments.itemid>
		
		<cfif structkeyexists(variables.eventsinfo, "nositeid") AND variables.eventsinfo.nositeid>
			<cfset conditions.nositeid = true>
		</cfif>
		
		<cfreturn lm.getAll(conditions)>
	</cffunction>
		
	<cffunction name="getUserHistory">
		<cfargument name="page" default="1">
		
	</cffunction>
	
	<cffunction name="event">
		<cfargument name="eventname" required="true">
		<cfargument name="modelRef" required="true">
		<cfargument name="moreInfo" default="#structnew()#">
		
		<cfset var logMdl = getLogModel().clear()>
		<cfset var s = structnew()>
		<cfset var s2 = "">
		
		<!--- determine if event is hearable --->
		<cfif NOT iseventhearable(eventname)>
			<cfreturn>
		</cfif>
		
		<!--- TODO : add code for custom method here as alternative to using replaceable string --->
		
		<!--- figure definition --->
		<cfset s2 = getEventInfo(eventName, modelref, moreinfo)>
		
		<!--- pack logModel with data and save --->
		<cfset logMdl.setModuleName(s2.moduleName)>
		
		
		
		<cfif modelRef.hasField(s2.itemidstr) AND modelRef.getField(s2.itemidstr) NEQ "">
			<cfset logMdl.setItemId( modelRef.getField(s2.itemidstr) )>
		<cfelseif structkeyexists(moreInfo,s2.itemidstr)>
			<cfset logMdl.setItemId( moreInfo[s2.itemidstr] )>
		<cfelse>
			<cfthrow message="system logs requires id to be set either in model or in more info">
		</cfif>
		
		<cfset logMdl.setDescription(s2.message)>
		<cfset logMdl.setTableName(s2.tableName)>
		<cfset logMdl.setSiteId(s2.siteid)>
		<cfset logMdl.setType("user")>
		
		<cfif NOT logMdl.save()>
			<cfdump var="#logMdl.getValidator().getErrors()#">
			<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="iseventhearable">
		<cfargument name="evt">
		<cfif structkeyexists(variables.eventsInfo.events, evt)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getEventInfo">
		<cfargument name="event" required="true">
		<cfargument name="modelref" required="true">
		<cfargument name="moreInfo" >
		
		<cfset var evt = variables.eventsInfo.events[event]>
		<cfset var r = structnew()>
		<cfset var s = structnew()>
		
		<cfif structkeyexists(evt,"tablename")>
			<cfset r.tablename = evt.tablename>
		<cfelse>
			<cfset r.tablename = variables.eventsinfo.tablename>
		</cfif>	
		
		<cfif structkeyexists(evt,"module")>
			<cfset r.modulename = evt.module>
		<cfelse>
			<cfset r.modulename = variables.eventsinfo.modulename>
		</cfif>
		
		<cfif structkeyexists(evt, "nositeid") AND evt.nositeid>
			<cfset r.siteid = "">
		<cfelse>
			<cfset r.siteid = variables.userObject.getCurrentSiteId()>
		</cfif>
		
		<cfif structkeyexists(evt, "alternateitemidstr")>
			<cfset r.itemidstr = evt.alternateitemidstr>
		<cfelse>
			<cfset r.itemidstr = "id">
		</cfif>
		
		<cfset r.message = evt.message>
	
		<cfset s.morereplaceables = morereplaceables(modelref, moreinfo)>
		<cfset s.re = "\{[^}]+\}">
		<cfset s.reObj = refindnocase(s.re, evt.message, 1, true)>

		<cfloop condition="s.reObj.pos[1] NEQ 0">
			<cfset s.str = mid(r.message, s.reObj.pos[1], s.reObj.len[1])>
			<cfset s.name = mid(s.str, 2, len(s.str)-2)>

			<cfif arguments.modelRef.hasField(s.name)>
				<cfset r.message = replacenocase(r.message, s.str, arguments.modelRef.getField(s.name))>
			</cfif>
			
			<cfif structkeyexists(moreInfo, s.name)>
				<cfset r.message = replacenocase(r.message, s.str, moreInfo[s.name])>
			</cfif>
			
			<cfif structkeyexists(s.morereplaceables, s.name)>
				<cfset r.message = replacenocase(r.message, s.str, s.morereplaceables[s.name])>
			</cfif>
			
			<cfset r.message = replacenocase(r.message, s.str, "uhhhh?")>
			<cfset s.reObj = refindnocase(s.re, r.message, 1, true)>

		</cfloop>
		
		<cfset r.message = ucase(left(r.message,1)) & right(r.message,len(r.message)-1)>
		
		<cfset r.message = rereplacenocase(r.message, "^(update) ", "\1d ")>
		<cfset r.message = rereplacenocase(r.message, "^(insert) ", "\1ed ")>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="morereplaceables">
		<cfreturn structnew()>
	</cffunction>
</cfcomponent>