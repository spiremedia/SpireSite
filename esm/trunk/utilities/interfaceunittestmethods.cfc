<cfcomponent name="interfaceunittest" extends="mxunit.framework.TestCase">
	<cffunction name="getSaHttpObj" access="private">
		<cfreturn createObject('component','login.logintest').getLoggedInSAUser()>>
	</cffunction>
	
	<cffunction name="setupTestPage" access="private">
		<cfset var httpObj = getSaHttpObj()>
		<cfset var response = "">
		
		<cfset httpObj.setPath('/Pages/AddPage/')>
		<cfset response = httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while loading add page form")>
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see addform")>
	
		<!--- submit new page, check logs to see if logged --->
		<!--- first figure out form fields to send  --->
		<cfset l.fs = response.getESMFormStruct()>

		<cfset l.hpid = response.getByPattern('<a id=''[A-Z0-9\-]{35}'' href')>
		<cfset l.hpid = mid(l.hpid, 8, len(l.hpid) - 13)>	
		
		<!--- see if interior2column template exists. Otherwise use first inlist--->
		<cfif response.existsByPattern("name=""template""[ ]+>.+?<option  value=""Interior2Column"">.+?</select>")>
			<cfset l.template = "interior2column">
		<cfelse>
			<cfset l.template = response.getByPattern("name=""template""[ ]+>[ ]*?<option[ ]+value=""([^""]+)+"">",2)>
		</cfif>

		<!--- submit new page --->
		<cfset httpObj.setPath(response.getESMSubmitsTo())>
		
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
				
		<cfset httpObj.addFormField("pagename", "unittestingpageunittestingpage")>
		<cfset httpObj.addFormField("pageurl", "unittestingpageunittestingpage")>
		<cfset httpObj.addFormField("template", l.template)>
		<cfset httpObj.addFormField("title", "unit testing page")>
		<cfset httpObj.addFormField("parentid", l.hpid)>
		<cfset httpObj.addFormField("summary", "ut.sum")>
		<cfset httpObj.addFormField("description", "ut desc")>
		
		<cfset response = httpObj.load()>
		<cfset httpObj.clear()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while submitting new page")>
		<cfset asserttrue(condition=(response.existsByPattern("Page Added")), message="Page should have been inserted.")>
		
		<cfset l.rjson = deserializejson(response.getHTML())>
		<cfset l.id = right(l.rjson.relocate, 35)>
		<cfset l.editlink = l.rjson.relocate>
		
		<!--- load update page and check useful fields and see if logs are following --->
		<cfset response = httpObj.setPath(l.rjson.relocate).load()>
		<cfset l.fs = response.getESMFormstruct()>
		
		<cfset asserttrue(condition=(response.existsByPattern("<dt>Page History</dt>.+Added page ""/unittestingpageunittestingpage.+<dt>Keyword Analysis</dt>")), message="Did not find evidence in logs of insert for this page.")>
		
		<!--- save page, check logs to see if logged --->
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		<cfset httpObj.addFormField("publish", "true")>
		
		<cfset response = httpObj.setPath(response.getESMSubmitsTo()).load()>
		<cfset httpObj.clear()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while updating")>

		<cfset asserttrue(condition=(response.existsByPattern("Page updated and Published")), message="Page should have been published.")>
		
		<cfset response = httpObj.setPath(l.editlink).load()>
		
		<!--- is on site --->
		<cfset l.link = response.getByPattern('published page url.+<a href="([^""]+)" target="_blank">[^""]+</a>.+Crosslink',2)>
		<cfhttp method="get" url="#l.link#" result="l.r">
		
		<cfset asserttrue(condition=(left(l.r.statuscode, 3) EQ "200"), message="Page is not published")>
		
		<cfset l.rs = structnew()>
		<cfset l.rs.id = l.id>
		<cfset l.rs.hpid = l.hpid>
		<cfset l.rs.editlink = l.editlink>
		<cfset l.rs.pageurl = l.link>
		
		<cfreturn l.rs>
	</cffunction>
	
	<cffunction name="teardown" access="private">
		<cfset var me = "">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM sitepages WHERE pagename like 'unittestingpageunittestingpage%'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activityLogs WHERE description LIKE '%unittestingpageunittestingpage%'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM workflow WHERE comment LIKE '%unittestingunittesting%'
		</cfquery>
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