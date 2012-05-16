<cfcomponent displayname="pagemanagementtypeTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset teardown()>
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset var me = "">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM sitepages WHERE pagename like 'unittestingpageunittestingpage%'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activityLogs WHERE description LIKE '%unittestingpageunittestingpage%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
		
		<!--- load top of pages --->
		<cfset variables.httpObj.setPath('/pages/StartPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while loading top page")>
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see top of pages")>
		<cfset asserttrue(condition=response.existsByPattern('<dt id="[A-Z0-9\-]{35}_label" class="empty">'), message="Site does not have subpages. Cannot test.")>
		
		<!--- check nav ajax works, isolate id of first subpage, then load that thru ajax method--->
		<cfset l.s = response.getByPattern('<dt id="[A-Z0-9\-]{35}_label" class="empty">')>
		<cfset l.s = mid(l.s, 9, len(l.s)-30)>
		
		<cfset variables.httpObj.setPath('/pages/getMenuSection/?pageid=#l.s#&selectedid=')>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=response.existsByPattern("<a  href=""/pages/editPage/\?id=#l.s#"), message="Could not find page in getmenusection ajax method")>
		
		<!--- get addpage form --->
		
		<cfset variables.httpObj.setPath('/Pages/AddPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while loading add page form")>
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see addform")>
	

		<!--- submit new page, check logs to see if logged --->
		<!--- first figure out form fields to send  --->
		<cfset l.fs = response.getESMFormStruct()>

		<cfset l.hpid = response.getByPattern('<a id=''[A-Z0-9\-]{35}'' href')>
		<cfset l.hpid = mid(l.hpid, 8, len(l.hpid) - 13)>	
		
		<!--- see if interior2column template exists. Otherwise use first --->
		<cfif response.existsByPattern("name=""template""[ ]+>.+?<option  value=""Interior2Column"">.+?</select>")>
			<cfset l.template = "Interior2Column">
		<cfelse>
			<cfset l.template = response.getByPattern("name=""template""[ ]+>[ ]*?<option[ ]+value=""([^""]+)+"">",2)>
		</cfif>

		<!--- submit new page - check validation --->
		<cfset variables.httpObj.setPath(response.getESMSubmitsTo())>
		
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
				
		<cfset response = variables.httpObj.load()>
		<cfset l.rjson = deserializejson(response.getHTML())>
		<cfset l.issues = structnew()>
		
		<cfloop array="#l.rjson.validation#" index="l.idx">
			<cfset l.issues[l.idx.field] = 1>
		</cfloop>
		
		<cfloop list="pagename,pageurl,template,title,parentid" index="l.idx">
			<cfset asserttrue(condition=(structkeyexists(l.issues, l.idx)), message="Form validation did not find form field #l.idx#.")>
		</cfloop>
		
		<cfset variables.httpObj.addFormField("pagename", "unittestingpageunittestingpage")>
		<cfset variables.httpObj.addFormField("pageurl", "unittestingpageunittestingpage")>
		<cfset variables.httpObj.addFormField("template", l.template)>
		<cfset variables.httpObj.addFormField("title", "unit testing page")>
		<cfset variables.httpObj.addFormField("parentid", l.hpid)>
		<cfset variables.httpObj.addFormField("summary", "ut.sum")>
		<cfset variables.httpObj.addFormField("description", "ut desc")>
		
		<cfset response = variables.httpObj.load()>
		<cfset variables.httpObj.clear()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while submitting new page")>
		<cfset asserttrue(condition=(response.existsByPattern("Page Added")), message="Page should have been inserted.")>
		
		<cfset l.rjson = deserializejson(response.getHTML())>
		<cfset l.id = right(l.rjson.relocate, 35)>
		
		<!--- check in draft pages --->
		<cfset response = variables.httpObj.setPath("/Pages/DraftPages/").load()>
		<!--- TODO:may need to page thru the paged draft pages here --->
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while viewing draft pages")>
		<cfset asserttrue(condition=(response.existsByPattern(l.id)), message="Page not found in drafts area.")>
		
		<cfset l.editlink = l.rjson.relocate>
		
		<!--- load update page and check useful fields and see if logs are following --->
		<cfset response = variables.httpObj.setPath(l.rjson.relocate).load()>
		<cfset l.fs = response.getESMFormstruct()>
		
		<cfset asserttrue(condition=(response.existsByPattern("<dt>Page History</dt>.+Added page ""/unittestingpageunittestingpage.+<dt>Keyword Analysis</dt>")), message="Did not find evidence in logs of insert for this page.")>
		
		<!--- save page, check logs to see if logged --->
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.setPath(response.getESMSubmitsTo()).load()>
		<cfset variables.httpObj.clear()>
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while updating")>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while updating")>
		<cfset asserttrue(condition=(response.existsByPattern("Page Updated")), message="Page should have been updated.")>
		<cfset l.rjson = deserializejson(response.getHTML())>
		
		<!--- check ajax method for reloading left nav --->
		<cfset asserttrue(condition=(isdefined("l.rjson.ajaxupdater.url")), message="response did not contain update for left nav.")>
		<cfset response = variables.httpObj.setPath(l.rjson.ajaxupdater.url).load()>
		<cfset assertfalse(condition=(response.existsByPattern(l.id)), message="left nav replace should not contain id.")>	
		
		<!--- publish page, check logs to see if logged --->
		<cfset response = variables.httpObj.setPath(l.editlink).load()>
		<cfset l.fs = response.getESMFormstruct()>
		<cfset l.fs.publish = true>
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		<cfset response = variables.httpObj.setPath(response.getESMSubmitsTo()).load()>
		<cfset variables.httpObj.clear()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while publishing")>
		<cfset asserttrue(condition=(response.existsByPattern("Page Updated and published")), message="Page should have been updated and published.")>
		
		<!--- check ajax method for reloading left nav --->
		<cfset asserttrue(condition=(isdefined("l.rjson.ajaxupdater.url")), message="response did not contain uppdate for left nav.")>
		<cfset response = variables.httpObj.setPath(l.rjson.ajaxupdater.url).load()>
		<cfset asserttrue(condition=(response.existsByPattern(l.id)), message="left nav replace should  contain id.")>	
		
		<cfset response = variables.httpObj.setPath(l.editlink).load()>
		
		<!--- are logs reflecting --->
		<cfset asserttrue(condition=(response.existsByPattern("<dt>Page History</dt>.+Published page ""/unittestingpageunittestingpage.+<dt>Keyword Analysis</dt>")), message="Did not find evidence of logs for publish for this page.")>
		
		<!--- is on site --->
		<cfset l.link = response.getByPattern('published page url.+<a href="([^""]+)" target="_blank">[^""]+</a>.+Crosslink',2)>
		<cfhttp method="get" url="#l.link#" result="l.r">
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Page is not published")>
		
		<!--- move up or down --->
		<cfquery name="l.corder" datasource="#request.requestObject.getVar("dsn")#">
			SELECT sort
			FROM sitepages
			WHERE id = <cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar">
				AND siteid LIKE <cfqueryparam value="%:staged" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset response = variables.httpObj.setPath("/pages/moveupdown/?dir=up&id=#l.id#").load()>
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error moving page up")>
		
		<!--- move up or down, logs follow --->
		<cfquery name="l.norder" datasource="#request.requestObject.getVar("dsn")#">
			SELECT sort
			FROM sitepages
			WHERE id = <cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar">
				AND siteid LIKE <cfqueryparam value="%:published" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=(l.corder.sort EQ l.norder.sort +1), message="Did not move page up")>
		
		<cfset response = variables.httpObj.setPath(l.editlink).load()>
		<cfset asserttrue(condition=(response.existsByPattern("<dt>Page History</dt>.+""/unittestingpageunittestingpage.+moved up.+<dt>Keyword Analysis</dt>")), message="Did not find evidence of logs for moving page up down for this page.")>

		<!--- test expiration --->
		<cfset response = variables.httpObj.setPath(l.editlink).load()>
		<cfset l.fs = response.getESMFormstruct()>
		<cfset l.fs.publish = true>
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		<cfset variables.httpObj.addFormField("showdate", "02/09/#YEAR(NOW())+1#")>
		<cfset response = variables.httpObj.setPath(response.getESMSubmitsTo()).load()>
		<cfset asserttrue(condition=(response.getStatus() EQ 200), message="Error moving page up")>
		<cfset variables.httpObj.clear()>
		
		<cfhttp method="get" url="#l.link#?reset" result="l.r">
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Expired page is having an issue")>
		<cfset asserttrue(condition=(findnocase("This page is expired", l.r.filecontent)), message="Expired page does not say its expired.")>
		
		<!--- add child --->
		<cfset variables.httpObj.setPath('/Pages/AddPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while loading add page form")>
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see addform")>
	

		<!--- submit new page, check logs to see if logged --->
		<!--- first figure out form fields to send  --->
		<cfset l.fs = response.getESMFormStruct()>
		<cfset l.fs.template = "interior2column">
		<cfset l.fs.parentid = l.id>
		
		<!--- submit new page - check validation --->
		<cfset variables.httpObj.setPath(response.getESMSubmitsTo())>
		
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.addFormField("pagename", "unittestingpageunittestingpage2")>
		<cfset variables.httpObj.addFormField("pageurl", "unittestingpageunittestingpage2")>
		<cfset variables.httpObj.addFormField("title", "unit testing page 2")>

		<cfset variables.httpObj.addFormField("summary", "ut.sum")>
		<cfset variables.httpObj.addFormField("description", "ut desc")>
				
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Problem creating subpage")>
		<cfset asserttrue(condition=(response.existsByPattern("Page Added")), message="Page should have been inserted.")>
		<cfset variables.httpObj.clear()>
		<cfset l.childid = response.getByPattern("id=([A-Z0-9\-]{35})",2)>

		<!--- test delete parent --->
		<cfset response = variables.httpObj.setPath("/Pages/DeletePage/?id=#l.id#").load()>
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Error trying to delete page")>
		<cfset asserttrue(condition=(response.existsByPattern("This item has children")), message="Did get error message while trying to delete parent")>
	
		<!--- test delete parent --->
		<cfset response = variables.httpObj.setPath("/Pages/DeletePage/?id=#l.id#").load()>
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Error trying to delete page")>
		<cfset asserttrue(condition=(response.existsByPattern("This item has children")), message="Didnt get validation error message while trying to delete parent")>
	
		<!--- test delete child --->
		<cfset response = variables.httpObj.setPath("/Pages/DeletePage/?id=#l.childid#").load()>
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Error trying to delete page")>
		<cfset asserttrue(condition=(response.existsByPattern("The Page has been deleted")), message="Didnt get success message while trying to delete chidl")>
	
		<!--- confirm deleted --->
		<!--- move up or down, logs follow --->
		<cfquery name="l.dead" datasource="#request.requestObject.getVar("dsn")#">
			SELECT id
			FROM sitepages
			WHERE id = <cfqueryparam value="#l.childid#" cfsqltype="cf_sql_varchar">
				AND siteid LIKE <cfqueryparam value="%:published" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset asserttrue(condition=(l.dead.recordcount EQ 0), message="Record not deleted")>
		
		<!--- see delete logs --->
		<cfset variables.httpObj.setPath('/pages/StartPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.existsByPattern("Deleted Page.+/unittestingpageunittestingpage/unit")), message="Did not find evidence in logs for deleting child page.")>
		
	</cffunction>
	
	<cffunction name="die" access="private">
		<cfargument name="a">
		<cfif issimplevalue(a)>
			<cfoutput>#a#</cfoutput>
		<cfelse>
			<cfdump var=#a#>
		</cfif>
		<cfabort>
	</cffunction>
	
</cfcomponent>
		