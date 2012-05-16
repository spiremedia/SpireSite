<cfcomponent name="contentLink" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var persist = dispatcher.getPersistence()>
		<cfset var viewname = 'views-' & arguments.userobj.getCurrentSiteId()>
		<cfset var info = structnew()>
		<cfset var tpltinfo = "">
		<cfset var spotname_for_query = "">
		<cfset var spotname_for_tplt = "">
		
		<cfif requestObject.getFormUrlVar("type") EQ "block">
			<cfset userObj.setFlash("The item clicked on is a block. You can Edit this block via the pages blocks admin or override it with a pageobject here.")>
		</cfif>
		
		<cfif not arguments.requestObject.isformurlvarset('name')>
			<cfthrow message="error in edit page - name url var not set">
		</cfif>
		
		<cfset spotname_for_query = arguments.requestObject.getformurlvar('name')>
		<cfset spotname_for_tplt = spotname_for_query>
		
		<cfif find("|",spotname_for_query)>
			<cfset spotname_for_query = gettoken(spotname_for_query,2,"|")>
			<cfset spotname_for_tplt = gettoken(spotname_for_tplt,1,"|")>
		</cfif>

		<cfif not arguments.requestObject.isformurlvarset('pageid')>
			<cfthrow message="error in edit page - name pageid var not set">
		</cfif>
		
		<!--- <cfif not arguments.requestObject.isformurlvarset('template')>
			<cfthrow message="error in edit page - template url var not set">
		</cfif> --->
		
		<cfif not arguments.requestObject.isformurlvarset('siteid')>
			<cfthrow message="error in edit page - info siteid var not set">
		</cfif>
		        
		<cfif arguments.userObj.getCurrentSiteId() NEQ arguments.requestObject.getFormUrlVar('siteid')>
			WRONG SITE IS BEING EDITED. PLEASE RELOGIN<cfabort>
		</cfif>

		<cfif NOT persist.isvarset('viewname')>
			<cfset views = createObject('component', 'resources.clientTemplates').init(requestObject, userobj).get()>
			<cfset persist.setVar(viewname, views)>
		<cfelse>
			<cfset views = persist.getvar('views')>
		</cfif>
		
		<cfset tpltinfo = views[arguments.requestObject.getFormUrlVar('template')]>

		<cfloop query="tpltinfo">
			<cfif tpltinfo.name EQ spotname_for_tplt>
				<cfset info.module = tpltinfo.modulename>
				<cfset info.name = spotname_for_tplt>
				<cfset info.parameterlist = tpltinfo.parameterlist>
				<cfbreak>
			</cfif>
		</cfloop>
		
		<cfset info.pageid = arguments.requestObject.getFormUrlVar('pageid')>
		<cfset info.template = arguments.requestObject.getFormUrlVar('template')>
		<cfset info.objname = spotname_for_query>
	
		<cfset displayObject.setData('info', info )>
	</cffunction>
	
	<cffunction name="edit">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        <cfargument name="dispatcher" required="true">

		<cfset var persist = dispatcher.getPersistence()>
		<cfset var viewname = 'views-' & arguments.userobj.getCurrentSiteId()>
		<cfset var itm = "">
        <cfset var info = "">
		<cfset var tpltinfo = "">
		<cfset var spotname_for_query = "">
		<cfset var spotname_for_tplt = "">
				
		<cfif not arguments.requestObject.isformurlvarset('id')>
			<cfthrow message="error in edit page - id url var not set">
		</cfif>
        
        <cfif arguments.userObj.getCurrentSiteId() NEQ arguments.requestObject.getFormUrlVar('siteid')>
			WRONG SITE IS BEING EDITED. PLEASE RELOGIN<cfabort>
		</cfif>
        
		<cfset spotname_for_query = arguments.requestObject.getformurlvar('name')>
		<cfset spotname_for_tplt = spotname_for_query>
		
		<cfif find("|",spotname_for_query)>
			<cfset spotname_for_query = gettoken(spotname_for_query,2,"|")>
			<cfset spotname_for_tplt = gettoken(spotname_for_tplt,1,"|")>
		</cfif>
		
		<cfif arguments.userObj.getCurrentSiteId() NEQ arguments.requestObject.getFormUrlVar('siteid')>
			WRONG SITE IS BEING EDITED. PLEASE RELOGIN<cfabort>
		</cfif>
 		
		<cfset info = structnew()><!--- variables.getUtility('json', arguments).decode( arguments.requestObject.getFormUrlVar('info') )> --->
		<cfset info.id = arguments.requestObject.getFormUrlVar('id')>
		
        <cfquery name="info.items" datasource="#arguments.requestObject.getvar('dsn')#" result="m">
			SELECT id, [module], memberType FROM pageObjects 
			WHERE pageid = <cfqueryparam value="#arguments.requestObject.getFormUrlVar('pageid')#" cfsqltype="cf_sql_varchar">
                AND siteid = <cfqueryparam value="#arguments.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND name = <cfqueryparam value="#spotname_for_query#" cfsqltype="cf_sql_varchar">
                AND status = 'staged'
				and deleted = 0
		</cfquery>
		
		<cfif NOT persist.isvarset('viewname')>
			<cfset views = createObject('component', 'resources.clientTemplates').init(requestObject, userobj).get()>
			<cfset persist.setVar(viewname, views)>
		<cfelse>
			<cfset views = persist.getvar('views')>
		</cfif>
		
		<cfset tpltinfo = views[arguments.requestObject.getFormUrlVar('template')]>

		<cfloop query="tpltinfo">
			<cfif tpltinfo.name EQ spotname_for_tplt>
				<cfset info.module = tpltinfo.modulename>
				<cfset info.name = spotname_for_tplt>
				<cfset info.parameterlist = tpltinfo.parameterlist>
				<cfbreak>
			</cfif>
		</cfloop>
			
		<cfset sitemembertypes = dispatcher.callExternalModuleMethod('sitememberTypes','getAvailableMemberTypes', requestObject, userobj)>
		
		<!--- if only one membertype, then go directly to module editor --->
		<cfif sitemembertypes.recordcount EQ 0>
			<cflocation url="/#info.items.module#/editClientModule/?id=#info.items.id#" addtoken="no">
		</cfif>
		
		<cfset displayObject.setData('memberTypes', sitemembertypes )>
   
		<cfset displayObject.setData('info', info )>
	</cffunction>
	
	<cffunction name="SaveModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var itm = "">
		<cfset var lcl = structnew()>
		<cfset var local2 = structnew()>
		<cfset var existing = 1>
		<cfset var po = createObject("component","resources.pageObjectsModel").init(requestObject, userObj)>
		<cfset var spotname = arguments.requestObject.getformurlvar('objname')>
		<cfset po.attachObserver(createObject("component","resources.pageObjectsLog").init(requestObject, userObj))>

		<cfset po.clear()>
		<cfset po.setPageId(arguments.requestObject.getformurlvar('pageid'))>
		<cfset po.setModule(arguments.requestObject.getformurlvar('mdl'))>
		<cfset po.setName(spotname)>
		<cfset po.setData(createObject('component','utilities.json').encode(lcl))>
		<cfset po.setStatus('staged')>
		<cfset po.setMemberType(arguments.requestObject.getformurlvar('memberType'))>
		
		<cfset local2 = duplicate(po.getValues())>
		<cfset structdelete(local2, "data")>
		<cfset structdelete(local2, "module")>
				
		<cfset existing = po.getAll(local2)>
				
		<cfif existing.recordcount NEQ 0>
			<cfset lcl.relocate = "/#existing.module#/editClientModule/?id=#existing.id#">
			<cfset displayObject.sendJson( lcl )>
		<cfelse>
			<cfset po.save()>
			<cfset lcl.relocate = "/#arguments.requestObject.getformurlvar('mdl')#/editClientModule/?id=#po.getId()#">
			<cfset displayObject.sendJson( lcl )>
		</cfif>
		
	</cffunction>
    
</cfcomponent>