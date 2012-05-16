<cfcomponent displayname="workflow Test" extends="utilities.interfaceunittestmethods">
	
	<cffunction name="setup">
		<cfset super.teardown()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset super.teardown()>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
		
		<cfset saHttpObj = getSaHttpObj()>
		<cfset testPage = setupTestPage()>
		
		<!--- gethpowner --->
		<cfset l.id = testpage.id>
		<cfset l.count = 0>
		<cfset l.owners = arraynew(1)>
	
		<cfquery name="l.hpownerinfo" datasource="#request.requestObject.getVar("dsn")#">
			SELECT sitepages.ownerid, users.fname, users.lname, users.username
			FROM sitepages
			INNER JOIN users ON sitepages.ownerid = users.id
			WHERE sitepages.id = <cfqueryparam value="#testpage.hpid#" cfsqltype="cf_sql_varchar">
				AND sitepages.siteid LIKE <cfqueryparam value="%:staged" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset asserttrue(condition=(l.hpownerinfo.recordcount EQ 1),message="Did not find owner of home page correctly. Possibly not set.")>	
		
		<!--- start reversion --->
		<cfset saHttpObj.setPath('/pages/startReview/?id=#testpage.id#')>
		<cfset response = saHttpObj.load()>
		<cfset assertfalse(condition=(response.didError()),message="Error getting reversion page")>
		
		<!--- check owner is in list --->
		<cfset asserttrue(condition=(response.existsByPattern("name=""reviewerId"".+<option.+value=""#l.hpownerinfo.ownerid#"">")), message="Did not find owner in request review page")>
	
		<!--- check validation then send it --->
		<cfset l.fs = response.getESMFormStruct()>

		<cfset saHttpObj.setPath(response.getESMSubmitsTo())>		

		<cfloop collection="#l.fs#" item="l.idx">
			<cfset saHttpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		
		<cfset saHttpObj.addFormField("reviewerid", l.hpownerinfo.ownerid)>
		<cfset response = saHttpObj.load()>
				
		<cfset asserttrue(condition=(response.existsByPattern("Comment is required")), message="Did not find comment validation")>
	
		<cfset saHttpObj.addFormField("comments", "unittestingunittesting")>
		<cfset response = saHttpObj.load()>
	
		<cfset saHttpObj.clear()>
		
		<cfset assertfalse(condition=(response.didError()),message="Error submitting request for review")>
		<cfset asserttrue(condition=(response.existsByPattern("Request for Review Sent")), message="request for review confirmation not found")>
		
		<!--- 
			note effectively sending review to self(sa) so don't need to 
			relogin as different user to see reviewable or reviseable pages 
		--->
		
		<!--- check in request review list, check in activitylog --->
		<cfset saHttpObj.setPath('/pages/ReviewablePages/')>
		<cfset response = saHttpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern(testpage.id)), message="page not found in reviewables list")>
		
		<!--- check back in pages to see if send feedback button is available --->
		<cfset saHttpObj.setPath(testpage.editlink)>
		<cfset response = saHttpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern("send feedback.+startRevise/\?id=#testpage.id#")), message="send feedback link not found")>
				
		<!--- view review form --->
		<cfset saHttpObj.setPath("/pages/startRevise/?id=#testpage.id#")>
		<cfset response = saHttpObj.load()>
		<cfset assertfalse(condition=(response.didError()),message="Error viewing request Revise form")>
		
		<!--- check validation then send it --->
		<cfset l.fs = response.getESMFormStruct()>
		
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset saHttpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		
		<cfset saHttpObj.setPath(response.getESMSubmitsTo())>
		<cfset response = saHttpObj.load()>
		
		<cfset asserttrue(condition=(response.existsByPattern("Comment is required")), message="comment validation did not occur for request review")>
		
		<cfset saHttpObj.addFormField("comments", "unittestingunittesting")>
		<cfset response = saHttpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern("Feedback Sent")), message="Did not get success message from submitting request revise")>

		<!--- check in revise list --->
		<cfset saHttpObj.setPath('/pages/ReviseablePages/')>
		<cfset response = saHttpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern(testpage.id)), message="page not found in reviseables list")>
		
		<!--- publish --->, check in logs, check no longer in lists --->
		<cfset saHttpObj.setPath(testpage.editlink)>
		<cfset response = saHttpObj.load()>
		
		<cfset l.fs = response.getESMFormStruct()>
		
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset saHttpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		
		<cfset saHttpObj.addFormField("publish", "true")>
		<cfset saHttpObj.clear()>
		<cfset assertfalse(condition=(response.didError()),message="Error publishing page")>
		
		<!--- check in logs, check no longer in lists --->
		<cfset saHttpObj.setPath(testpage.editlink)>
		<cfset response = saHttpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern("Sent page ""/unittestingpageunittestingpage/"" for REVISION")), message="Did not find log noting revision")>
		<cfset asserttrue(condition=(response.existsByPattern("Sent page ""/unittestingpageunittestingpage/"" for REVIEW")), message="Did not find log noting review")>
		
	</cffunction>
</cfcomponent>
		