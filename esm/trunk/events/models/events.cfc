<cfcomponent name="Events Model" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfset variables.itemdata = structnew()>
		
		<cfset setTableMetaData('{	
			"tableName":"events",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Event Name"},
				"title":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Title"},
				"startdate":{"type":"date","validation":"notblank,isvaliddate","label":"Start Date"},
				"enddate":{"type":"date","validation":"notblank,isvaliddate","label":"End Date"},
				"starttime":{"type":"varchar","label":"Start Time"},
				"endtime":{"type":"varchar","label":"End Time"},
				"imageassetid":{"type":"varchar","maxlen":35},
				"agendaassetid":{"type":"varchar","maxlen":35},
				"locationname":{"type":"varchar","maxlen":75,"validation":"maxlength","label":"Location Name"},
				"location":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Location"},
				"searchdescription":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Search Description"},
				"shortdescription":{"type":"varchar","wysiwyg":1,"maxlen":600,"validation":"maxlength"},
				"description":{"type":"varchar","wysiwyg":1},
				"active":{"type":"bit","default":1},
				"maplink":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Map Link"},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"},
				"changedby":{"type":"varchar","maxlen":35},
				"siteid":{"type":"varchar","maxlen":35},
				"onhomepage":{"type":"bit"},
				"showmaterialsform":{"type":"bit"},
				"showaddtlattendees":{"type":"bit"},
				"archivedate":{"type":"date"}
			},
			"hasMany":{"events.eventattendees":{}}
		}')>
		<cfset variables.assetdirectoryname = "assets">
		<cfset variables.assetdirectorypath = variables.requestObj.getVar("machineroot") &  'docs/' & assetdirectoryname & '/'>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="deleteEvent" output="false">
		<cfargument name="id" required="true">
		
		<cfset var users = "">
		
		<cfset this.load(arguments.id)>
		<cfset variables.observeEvent('delete events', this)>
		<!---<cfset load(arguments.id)>
		<cfset variables.observeEvent('delete event', variables.itemData)> --->
		
		<cfquery name="users" datasource="#variables.requestObj.getvar('dsn')#">
			UPDATE events SET deleted=1
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
	</cffunction>

	<!--- <cffunction name="getEvents" output="false">
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, 
				name, 
				title, 
				startdate,
				modifieddate,
				modifieduser,
				onhomepage
			FROM events_view
			WHERE siteid = <cfqueryparam value="#variables.userobj.getCurrentSiteId()#">
			ORDER BY startdate
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="getEvent" output="false">
		<cfargument name="id">
		<cfset var e = "">
	
		<cfquery name="e" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, title, startdate, enddate, agendaassetid, 
				location, description,active, maplink, onhomepage,
				showmaterialsform, showaddtlattendees
			FROM events 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn e/>
	</cffunction>
	
	<cffunction name="getAttendees" output="false">
		<cfargument name="eventid">

		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id,email, lname, fname, title, phone, companyname, 
				add1, add2,  city, state, zip, 
				wantsmaterials, addtlattendeescount, 
				addtlattendeesinfo,signupdatetime, comment
			FROM eventattendees
			WHERE eventid = <cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar">
			ORDER BY signupdatetime
		</cfquery>

		<cfreturn r/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT e.id, e.name, e.modifieddate AS modified, u.lname + ' ' + u.fname AS fullname  
			FROM events_view e
            INNER JOIN dbo.users u ON u.id = e.modifieduser
			WHERE e.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
			AND e.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY e.name
		</cfquery>
		
		<cfreturn g>
	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
	
		<cfset variables.itemdata = arguments.itemdata>
		
		<cfif not StructKeyExists(variables.itemdata,'active')>
			<cfset variables.itemdata.active = 0>
		</cfif>
		
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfset mylocal.sameevent = search(requestvars.name,'name')>
	
		<!--- valiation for new users --->
		<cfif requestvars.id EQ "">
			<cfif mylocal.sameevent.recordcount>
				<cfset vdtr.addError('name','This Event Name is already taken, please choose another.')>
			</cfif>
		<cfelse><!--- validation for existing users --->
			<cfif mylocal.sameEvent.recordcount AND requestvars.id NEQ mylocal.sameevent.id>
				<cfset vdtr.addError('name','This Event Name is already taken, please choose another.')>
			</cfif>
		</cfif>
		
		<cfset vdtr.notblank('title', requestvars.title, 'The Title is required.')>
		<cfset vdtr.notblank('startdate', requestvars.startdate, 'The Start Date is required.')>
		<cfset vdtr.notblank('enddate', requestvars.enddate, 'The End Date is required.')>
		
		<cfset vdtr.maxlength('name', 50, requestvars.name, 'Event Name should not exceed 50 characters ')>
		<cfset vdtr.maxlength('title', 255, requestvars.title, 'Event title should not exceed 255 characters ')>
		<cfset vdtr.maxlength('location', 255, requestvars.location, 'Event location should not exceed 255 characters ')>
		<cfset vdtr.maxlength('maplink', 255, requestvars.maplink, 'Event map link should not exceed 255 characters ')>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfset sg = getEvent(id = arguments.id)>		
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ 0 or variables.itemData.id EQ ''>
			<cfset id = insertEvent(argumentcollection = variables.itemData)>
			<cfset variables.observeEvent('insert event', variables.itemData)>
		<cfelse>
			<cfset id = updateEvent(argumentcollection = variables.itemData)>
			<cfset variables.observeEvent('update event', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertEvent" output="false">
		
		<cfset var e = "">
		<cfset var id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		<cfquery name="e" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO events ( 
				id,
				name,
				title,
				active,
				location,
				description,
				startdate,
				enddate,
				agendaassetid,
				maplink,
				modifieduser,
				siteid,
				onhomepage,
				showmaterialsform,
				showaddtlattendees
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.location#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.enddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.agendaassetid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.maplink#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userobj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.onhomepage#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#variables.itemdata.showmaterialsform#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#variables.itemdata.showaddtlattendees#" cfsqltype="cf_sql_integer">
			)			
		</cfquery>
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateEvent" output="false">
		
		<cfset var q = "">
		<cfset var grp = "">
	
		<cfquery name="q" datasource="#variables.request.getvar('dsn')#">
			UPDATE events SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				title = <cfqueryparam value="#variables.itemdata.title#" cfsqltype="cf_sql_varchar">,
				active = <cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_varchar">,
				location = <cfqueryparam value="#variables.itemdata.location#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				startdate = <cfqueryparam value="#variables.itemdata.startdate#" cfsqltype="cf_sql_varchar">,
				enddate = <cfqueryparam value="#variables.itemdata.enddate#" cfsqltype="cf_sql_varchar">,
				agendaassetid = <cfqueryparam value="#variables.itemdata.agendaassetid#" cfsqltype="cf_sql_varchar">,
				maplink = <cfqueryparam value="#variables.itemdata.maplink#" cfsqltype="cf_sql_varchar">,
				onhomepage = <cfqueryparam value="#variables.itemdata.onhomepage#" cfsqltype="cf_sql_varchar">,
				showmaterialsform = <cfqueryparam value="#variables.itemdata.showmaterialsform#" cfsqltype="cf_sql_varchar">,
				showaddtlattendees = <cfqueryparam value="#variables.itemdata.showaddtlattendees#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
	</cffunction> --->
</cfcomponent>