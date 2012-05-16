<cfcomponent name="page" output="false">

	<cffunction name="init" output="false">
		<cfargument name="pageInfo" required="true">
		<cfargument name="requestObject" required="true">
		
		<cfset var data = structnew()>
		<cfset variables.requestObject = arguments.requestObject>

		<cfif 	NOT ispreview() 
				AND isdefined("arguments.pageinfo.relocate") 
				AND len(arguments.pageinfo.relocate)>
			<cflocation url="#arguments.pageinfo.relocate#" addtoken="no">
		</cfif>
        		
		<!--- is page is expired, show alternate --->
		<cfif isdefined("arguments.pageinfo.expired") AND arguments.pageinfo.expired>
			<cfset variables.pageinfo.template="_blank">
			<cfset variables.pageinfo.title = "Page is Expired">
			<cfset variables.pageinfo.description = "Page is Expired">
			<cfset variables.pageinfo.keywords = "Page is Expired">
			<cfset data.content = "This page is expired">
			<cfset addObjectByModulePath("oneContent", "htmlContent", "default", data)>
			<cfset showpage()>
			<cfabort>
		</cfif>
		
		<cfset variables.pageInfo = arguments.pageInfo>
		<cfset variables.queriedObjects = structnew()>
		<cfset variables.pageobjects = structnew()>
		<cfset variables.headerItems = structnew()>
		
		<cfparam name="arguments.pageInfo.parentid" default="0">
		<cfparam name="arguments.pageInfo.backgroundimage" default="">
		<cfparam name="variables.pageInfo.is404" default="false">
    
	    <cfif (NOT structkeyexists(variables.pageinfo, "description") OR variables.pageinfo.description EQ "")
			AND requestObject.isVarSet("defaultdescription")>
        	<cfset variables.pageinfo.description = requestObject.getVar("defaultdescription")>
        </cfif>
        
		<cfif (NOT structkeyexists(variables.pageinfo, "keywords") OR variables.pageinfo.keywords EQ "")
			AND requestObject.isVarSet("defaultkeywords")>
        	<cfset variables.pageinfo.keywords = requestObject.getVar("defaultkeywords")>
        </cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="preObjectLoad" output="false">
		<!--- do nothing, can be used by inheriting classes --->
	</cffunction>
	
	<cffunction name="addtoheader">
		<cfargument name="str" required="true">
		<cfset variables.headerItems[arguments.str] = 1>
	</cffunction>
	
	<cffunction name="getheaderitems">
		<cfreturn structkeylist(variables.headerItems, chr(10))>
	</cffunction>
	
	<cffunction name="postObjectLoad" output="false">
		<!--- do nothing, can be used by inheriting classes --->
	</cffunction>
	
	<cffunction name="getbreadcrumbs" output="false">
		<cfparam name="variables.pageinfo.breadcrumbs" default="">
		<cfreturn variables.pageinfo.breadcrumbs>
	</cffunction>
	
	<cffunction name="getField" output="false">
		<cfargument name="fieldname" required="true">
		<cfif not structkeyexists(variables.pageinfo, fieldname)>
			<cfthrow message="field '#fieldname#' not set in pageinfo">
		</cfif>
		<cfreturn variables.pageinfo[fieldname]>
	</cffunction>
	
	<cffunction name="isFieldSet" output="false">
		<cfargument name="fieldname" required="true">
		<cfreturn structkeyexists(variables.pageinfo, fieldname)>
	</cffunction>
    
    <cffunction name="setField" output="false">
		<cfargument name="fieldname" required="true">
        <cfargument name="value" required="true">
		
		<cfset variables.pageinfo[fieldname] = value>
	</cffunction>
	
	<cffunction name="getSiteMap" output="false">
		<cfif not structkeyexists(variables, 'sitemap')>
			<cfset variables.sitemap = createObject('component','resources.sitemap').init(variables.requestObject, this)>
		</cfif>
		<cfreturn variables.sitemap>
	</cffunction>
	
	<cffunction name="loadObjects" output="false">
		<!--- 
		page content objects get loaded here.  
		Use the module object to get all required ones deduced from the template. 
		Then combine with data from getObjects query
		--->
		<cfargument name="views" required="true">
		<cfargument name="modules" required="true">
		
		<cfset var requiredObjects = views.getView(pageInfo.template)>
		<cfset var existingObjects = setQueryData()>
		<cfset var moduleaction = "default">
		<cfset var data = "">
 
		<cfloop query="requiredObjects">
			<cfset moduleaction = "default">
			
			<cfif structkeyexists(requiredObjects.parameterlist, "moduleaction")>
				<cfset moduleaction = requiredObjects.parameterlist['moduleaction']>
			</cfif>
			
			<cfset data = duplicate(requiredObjects.parameterlist)>

			<!-- if there is a content object with the correct name in the queried objects -->
			<cfif structkeyexists(variables.queriedobjects, requiredObjects.name)>
				
				<cfif structkeyexists(variables.queriedobjects[requiredObjects.name].data, "moduleaction")>
					<cfset moduleaction = variables.queriedobjects[requiredObjects.name].data.moduleaction>
				</cfif>
				
				<!--- merge the data from the required objects (the items passed in the tplt definition) with the data from the queried object (deserialized json) --->
				<cfset structappend(data, variables.queriedobjects[requiredObjects.name].data)>
				
				<!--- set the id into the data so the obj can know where it comes from if neccessary --->
				<cfset data.pageObjectId = variables.queriedobjects[requiredObjects.name].id>
								
				<!--- load it --->
				<cfset addObject(	variables.queriedobjects[requiredObjects.name].id,
									requiredobjects.name, 
									modules.getModule(	module = variables.queriedobjects[requiredObjects.name].module, 
														requestObject = variables.requestObject,
														title = variables.queriedobjects[requiredObjects.name].title, 
														data = data,
														pageref = this,
														possiblemodules = requiredobjects.modulename,
														name = requiredobjects.name ),
									variables.queriedobjects[requiredObjects.name].module,
									moduleaction,
									variables.queriedobjects[requiredObjects.name].objtype )>
			<!-- if there is no content object for an editable spot, then give the blank editable module -->
			<cfelseif structkeyexists(parameterlist,'editable')>
				
				<cfset addObject(	'',
									requiredobjects.name, 
									modules.getModule(	module = 'blankeditable', 
														requestObject = variables.requestObject, 
														title = "",
														data = data,
														pageref = this,
														possiblemodules = requiredobjects.modulename,
														name = requiredobjects.name),
									"blankeditable",
									"default" )>
			<!-- Last case, this should be a default object like navigation or breadcrumbs -->
			<cfelse>
				<cfset addObject(	'',
									requiredobjects.name, 
									modules.getModule(	module = modulename, 
														requestObject = variables.requestObject, 
														title = IIF(structkeyexists(data, "title"), "data.title", DE("")),
														data = data,
														pageref = this,
														possiblemodules = requiredobjects.modulename,
														name = requiredobjects.name ),
									requiredobjects.modulename,
									moduleaction )>
			</cfif>
		</cfloop>

	</cffunction>
	
	<cffunction name="addObject" output="false">
		<cfargument name="id" required="true">
		<cfargument name="name" required="true">
		<cfargument name="obj" required="true">
		<cfargument name="module" required="true">
		<cfargument name="moduleaction" required="true">
		<cfargument name="objtype" default="unmanaged">
		
		<cfset var robj = "">
		
		<cfinvoke component="#obj#" method="#moduleaction#" returnvariable="robj">
			<cfinvokeargument name="module" value="#arguments.module#">
			<cfinvokeargument name="moduleaction" value="#arguments.moduleaction#">		
		</cfinvoke>
		
		<cfset variables.pageobjects[arguments.name] = structnew()>
		<cfset variables.pageobjects[arguments.name].obj = robj>
		<cfset variables.pageobjects[arguments.name].id = arguments.id>
		<cfset variables.pageobjects[arguments.name].module = arguments.module>	
		<cfset variables.pageobjects[arguments.name].moduleaction = arguments.moduleaction>	
		<cfset variables.pageobjects[arguments.name].objtype = arguments.objtype>	
		
		<cfreturn obj>
	</cffunction>
	
	<cffunction name="addObjectByModulePath" output="false">
		<cfargument name="name" required="true">
		<cfargument name="pathName" required="true">
		<cfargument name="title" default="">
		<cfargument name="data" default="#structnew()#">
		<cfargument name="moduleaction" default="default">

		<cfreturn addObject(
				"",
				arguments.name,
				createObject('component','modules.#arguments.pathName#.controller').init(
					data = arguments.data, 
						title = arguments.title,
							requestObject = variables.requestObject, 
								pageRef = this,
									name = arguments.name),
				arguments.pathName,
				arguments.moduleaction	
		)>
	</cffunction>
	
	<cffunction name="getObject" output="false">
		<cfargument name="name">
		<cfreturn variables.pageobjects[arguments.name].obj>
	</cffunction>
	
	<cffunction name="getObjectId" output="false">
		<cfargument name="name">
		<cfreturn variables.pageobjects[name].id>
	</cffunction>
	
	<cffunction name="showContentObject" output="false">
		<cfargument name="name" required="true">
		<cfargument name="module" required="true">
		<cfargument name="parameterlist" default="">
		
		<cfset var rhtml = structnew()>
		<cfset var html = "">
		<cfset var json = "">

		<!--- 
			1 this method invokes the module method, 
			2 then pieces toghether the pieces of html and 
			3 exposes them to the observsers and then returns the html to the page
		 --->

		<cfinvoke component="#variables.pageobjects[name].obj#" method="showhtml" returnvariable="html">
			<cfinvokeargument name="module" value="#variables.pageobjects[name].module#">
			<cfinvokeargument name="moduleaction" value="#variables.pageobjects[name].moduleaction#">
		</cfinvoke>
		
		<cfset rhtml.module = variables.pageobjects[name].module>
		<cfset rhtml.moduleaction = variables.pageobjects[name].moduleaction>
		<cfset rhtml.templatespot = arguments.name>
		
		<cfif isstruct(html)>
			<cfset rhtml.title = html.title>
			<cfset rhtml.html = html.html>
		<cfelse>
			<cfset rhtml.title = "">
			<cfset rhtml.html = html>
		</cfif>
		
		<cfif  trim(rhtml.html) EQ "" AND NOT ispreview()>
			<cfreturn "">
		</cfif>

		<cfif findnocase("nowrap", arguments.parameterlist)>
			<cfset rhtml.head = "">
			<cfset rhtml.foot = "">
			<cfset rhtml.title = "">
			<cfset rhtml.htmlhead = "">
			<cfset rhtml.htmlfoot = "">
			<cfset rhtml.tail = "">
		<cfelse>
			<cfset rhtml.head = '<div class="po#iif(len(rhtml.title), DE("_wtitle"), DE(""))# #variables.pageobjects[name].module# #variables.pageobjects[name].module#_#variables.pageobjects[name].moduleaction# #name#">
'>
			<cfif rhtml.title NEQ "">
				<cfset rhtml.title = '<div class="potitle"><h4>#rhtml.title#</h4></div>
'>
			</cfif>
			<cfset rhtml.htmlhead = '<div class="pocntnt">
'>			
			<cfset rhtml.htmlfoot = '</div>
'>			
			<cfset rhtml.foot = '<div class="pofoot"><div></div></div>
'>
			<cfset rhtml.tail = "</div>
">
		</cfif>
		
		<cfset rhtml.head = lcase(rhtml.head)>
	
		<cfif ispreview('edit') AND rhtml.html EQ '' AND find('editable', arguments.parameterlist)>
			<cfset rhtml.head = '<div class="hint">#name#</div>' & rhtml.head>
			'>
		</cfif>
		
		<cfif find('editable', arguments.parameterlist) AND ispreview('edit')>
			<cfset rhtml.esm = '<input class="contentObjectMarker" id="#getObjectId(name)#" rel="#variables.pageobjects[name].objtype#" type="hidden" name="#arguments.name#" value=''#getField("template")#''>
		'>
			<cfset rhtml.html = rhtml.html & '&nbsp;'>
		<cfelse>
			<cfset rhtml.esm = ''>
		</cfif>

		<cfset rhtml = requestObject.notifyObservers("moduleoutput.#rhtml.module#.#rhtml.moduleaction#", rhtml)>
		
		<cfreturn rhtml.head & rhtml.title & rhtml.htmlhead & rhtml.html & rhtml.htmlfoot & rhtml.foot & rhtml.esm & rhtml.tail>
	</cffunction>
	
	<cffunction name="ContentObjectNotEmpty" output="false">
		<cfargument name="name" required="true">
		<cfif ispreview('edit')>
			<cfreturn true>
		</cfif>
		<cfif structkeyexists(variables.pageObjects[name].obj, "notEmpty")>
			<cfreturn variables.pageObjects[name].obj.notEmpty()>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="setQueryData">
		<cfset var q ="">
		<cfset var jsonobj = createObject('component','utilities.json')>
		<cfset var me = "">
		<cfset var membertype = "">
		<cfset var pageid = 0>

		<cfif ispreview() AND requestObject.isFormUrlVarSet('showMemberType')>
			<cfset membertype = requestObject.getFormUrlVar('showMemberType')>
		<cfelse> 
			<cfset membertype = requestObject.getUserObject().getMemberType()>
		</cfif>
		
		<cfif structkeyexists(pageinfo, 'id')>
			<cfset pageid = getPageId()>
		</cfif>
		
		<cfset me = getSiteMap().getPageObjects(		
			pageid = pageId,
			path = requestObject.getFormUrlVar("path"),
			ispreview = ispreview(),
			memberType = memberType)>

		<cfoutput query="me" group="name">
			<!--- structure will already exist if content area exists for a marketing group, without this if, content would only be shown for default --->
			<cfif NOT structKeyExists(variables.queriedobjects, me.name)>
				<cfset queriedobjects[me.name] = structnew()>
				<!--- htmlcontent and simplecontent are published as straight content, not json --->
				<cfif left(me.data,1) EQ "{">
					<cfset queriedobjects[me.name].data = jsonobj.decode(me.data)>
				<cfelse>
					<cfset queriedobjects[me.name].data = structnew()>
					<cfset queriedobjects[me.name].data.content = me.data>
				</cfif>
				<cfset queriedobjects[me.name].id = me.id>
				<cfset queriedobjects[me.name].module = me.module>
				<cfset queriedobjects[me.name].title = me.title>
				<cfset queriedobjects[me.name].name = me.name>
				<cfset queriedobjects[me.name].objtype = me.objtype>
				
			</cfif>
		</cfoutput>
	
	</cffunction>
    	
	<cffunction name="getQueryData">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.queriedobjects,name)>
			<cfreturn "">
		<cfelse>
			<cfreturn variables.queriedobjects[name]>
		</cfif>
	</cffunction>
	
	<cffunction name="showPage">
    	<cfset var lcl = structnew()>

		<cfinclude template="../views/#variables.pageinfo.template#/index.cfm">
       
		<cfif ispreview()> 
            <link rel="stylesheet" href="/ui/esm/esm.css" type="text/css" />
			<script type="text/javascript" src="/ui/js/jquery-1.3.2.min.js"></script>
			<script type="text/javascript">jQuery.noConflict();</script>
            <script type="text/javascript" src="/ui/esm/jquery.esmclick.js"></script>
			<script type="text/javascript">
				jQuery.noConflict();
				jQuery(function(){ 
					<cfif requestObject.isFormUrlVarSet("preview") AND requestObject.getFormUrlVar("preview") EQ "edit">
						jQuery('a').click(function(){return false});
					<cfelse>
						jQuery('a').attr("target","_blank");//click(function(){return false});
					</cfif>
					<!---//jQuery('.contentObjectMarker').parent().hover(function(){
					//	jQuery(this).addClass("contentObject-edit");
					//},function(){
					//	jQuery(this).removeClass("contentObject-edit");
					//});--->
					<cfoutput>jQuery('.contentObjectMarker').esmclick({link:'#variables.requestObject.getVar('cmslocation')#contentLink/|action|/?pageid=#variables.getPageId()#&siteid=#variables.requestObject.getVar('siteid')#'});</cfoutput>
				});  
			</script>
		</cfif>
	</cffunction>
	
	<cffunction name="getMainMenu">
		<cfreturn variables.getSiteMap().getMainMenu()>
	</cffunction>
	
	<cffunction name="getSiblingPages">
		<cfreturn variables.getSiteMap().getSiblingPages()>
	</cffunction>
	
	<cffunction name="getChildPages">
		<cfargument name="id" default="#getPageId()#">
		<cfreturn variables.getSiteMap().getChildPages(arguments.id)>
	</cffunction>
    
    <cffunction name="getSectionPages">
		<cfreturn variables.getSiteMap().getSectionPages(gettoppageid())>
	</cffunction>
    
    <cffunction name="getSectionChildPages">
		<cfreturn variables.getSiteMap().getSectionPages(gettoppagechildid())>
	</cffunction>
	
	<cffunction name="getDHTMLnav">
		<cfargument name="id" required="no" default="">
		<cfreturn variables.getSiteMap().getDHTMLNav(arguments.id)>
	</cffunction>
	
	<cffunction name="gettoppageid" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.breadcrumbs = getbreadcrumbs()>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
		<cfif arraylen(lcl.breadcrumbs) gt 1>
			<cfreturn gettoken(lcl.breadcrumbs[2],2,"~")>
		</cfif>
		<cfreturn getPageId()>
	</cffunction>
	
	<cffunction name="gettoppagechildid" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.breadcrumbs = getbreadcrumbs()>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
		<cfif arraylen(lcl.breadcrumbs) gt 2>
			<cfreturn gettoken(lcl.breadcrumbs[3],2,"~")>
		</cfif>
		<cfreturn ''>
	</cffunction>
	
	<cffunction name="getPageId" output="false">
		<cfparam name="variables.pageinfo.id" default="">
		<cfreturn variables.pageinfo.id>
	</cffunction>
	
	<cffunction name="ispreview">
    	<cfargument name="previewtype" default="any">
		
		<cfif NOT variables.requestObject.isformurlvarset('preview')>
			<cfreturn false>
		</cfif>
        
        <cfif NOT isIPSafe(ip = CGI.REMOTE_ADDR)>
			<cfreturn false>
        </cfif>
        
        <cfif previewtype EQ 'any' AND variables.requestObject.isformurlvarset('preview')>
        	<cfreturn true>
        </cfif>
        
        <cfif listfind('edit,view', variables.requestObject.getformurlvar('preview')) 
			AND previewtype EQ variables.requestObject.getformurlvar('preview')>
        	<cfreturn true>
        </cfif>
        
        <cfreturn false>
	</cffunction>
	
    <cffunction name="isIPSafe">
		<cfargument name="ip" required="true">  
        <cfset var qry = "">
		
      	<cfparam name="variables.checkedSafeIp" default="">
	
        <cfif listfind(variables.checkedSafeIp, ip)>
			<cfreturn true>
        </cfif>

		<cfquery name="qry" datasource="#variables.requestObject.getVar('dsn')#" result="m">
			SELECT COUNT(*) cnt , DATEADD ( d , -1, getDate()) d 
			FROM securityIPs
			WHERE 
				ip = <cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar">
				AND (
						(usertype = 'User' AND accessDate >= DATEADD ( d , -1, getDate() ) )
						OR usertype = 'System'
					)
						
		</cfquery>
        
		<cfif qry.cnt>
			<cfset variables.checkedSafeIp = listappend(variables.checkedSafeIp, arguments.ip)>
		</cfif>

        <cfreturn qry.cnt>
    </cffunction>
	
	<cffunction name="set404">
		<cfargument name="send">
		<cfset setField('is404', send)>
	</cffunction>
	
	<cffunction name="is404">
		<cfreturn getField('is404')>
	</cffunction>
    
    <cffunction name="getCacheLength">
		<cfset var len = 100000>
		<cfset var itm = "">
		<cfset var locallen = 0>
		<cfset var debugstr = "">
		<cfloop collection="#variables.pageobjects#" item="itm">
			<cftry>
				<cfset locallen = variables.pageobjects[itm].obj.getCacheLength()>
				<!--- <cfset debugstr = debugstr & " " & variables.pageobjects[itm].name & " = " & locallen & "<br>"> --->
				<cfcatch>
					<cfoutput>item in ""#itm#"" has issue or does not have getCacheLength function</cfoutput>
					<cfabort>
				</cfcatch>
			</cftry>
			<cfif locallen EQ 0>
				<cfreturn 0>
			</cfif>
			<cfif locallen LT len>
				<cfset len = locallen>
			</cfif>
		</cfloop>
		<cfreturn len>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var m = structnew()>
		<cfset m.page = pageInfo>
		<cfset m.queriedObjects = queriedObjects>
		<cfset m.pageobjects = pageObjects>
		<cfdump var=#m#><cfabort>
	</cffunction>
	
</cfcomponent>