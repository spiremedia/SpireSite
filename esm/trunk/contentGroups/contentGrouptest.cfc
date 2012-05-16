<cfcomponent displayname="contentGroupTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset teardown()>
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset d = structnew()>
		<cfquery name="d.cg" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM contentGroups WHERE name = 'unittesting'
		</cfquery>

		<cfloop query="d.cg">
			<cfquery name="recordcgRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM contentGroups WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="recordcguRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM contentGroupUsers WHERE contentGroupId = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="recordcguRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM contentGroupLocations WHERE contentGroupId = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="recordcglogRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM activitylogs WHERE itemid = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="recordcglogRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM activitylogs WHERE description like <cfqueryparam value="%unittesting%" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfloop>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var iT = structnew()>
		<cfset var response = "">
		<cfset var data = structnew()>
		<cfset variables.httpObj.clear()>
		
		<!--- Testing add Content Group index --->
		<cfset variables.httpObj.setPath('/ContentGroups/startPage/')>
		<cfset response = variables.httpObj.load()>
		<cfset assertfalse(condition=(response.is302relocate()),message="User 'sa' logged in.  Unable to see Content Groups.")>
		
		<!--- Testing Add Content Group /AddContentGroup/ --->
		<cfset variables.httpObj.setPath('/ContentGroups/AddContentGroup/')>
		<cfset response = variables.httpObj.load()>
		<cfset iT.formFields = response.getESMFormFields()>
		<cfset assertfalse(condition=(len(iT.formFields) EQ 0),message="There are no form fields on the Add Content Group page.")>
		
		<!--- Testing Save Functionality for New Content Group --->
		<cfset iT.submitsto = response.getESMSubmitsTo()>
		<cfset variables.httpObj.setPath(iT.submitsto)>
		<cfset variables.httpObj.clear('formfield,urlfields')>
		<cfset iT.fields = structnew()>
		
		<cfloop list="#iT.formfields#" index="iT.idx">
			<cfset iT.fields[iT.idx] = "">
		</cfloop>
		
     	<cfset iT.fields['id'] = 0>    
		<cfset iT.fields['name'] = "">
		<cfset iT.fields['Description'] = "">
		
		<cfloop collection="#iT.fields#" item="iT.idx">
			<cfset variables.httpObj.addFormField(iT.idx, iT.fields[iT.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error while saving new Content Group.")>
             
		<cfset iT.fields['name'] = "unittesting">
		<cfset iT.fields['description'] = "ut desc">
		
		<!--- get some users --->
		<cfquery name="data.getsomeusersquery" datasource="#request.requestObject.getVar('dsn')#">
		SELECT top 2 id FROM users WHERE deleted = 0 AND active = 1
		</cfquery>
		<cfset iT.fields['usersingroup'] = valuelist(data.getsomeusersquery.id)>
		
		<!--- get some pages --->
		<cfquery name="data.getsomepagesquery" datasource="#request.requestObject.getVar('dsn')#">
		SELECT distinct top 2 id FROM sitepages WHERE status = 'Published'
		</cfquery>
		<cfset iT.fields['sitepages'] = valuelist(data.getsomepagesquery.id)>
		
		<cfloop collection="#iT.fields#" item="iT.idx">
		<cfset variables.httpObj.addFormField(iT.idx, iT.fields[iT.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while saving new Content Group.")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="The validation function did not validate form field: name.")>
		<cfset asserttrue(condition=(response.existsByPattern("content group added")),message="The system did not confirm that the item was added")>

		<!--- check contentGroup record correct --->
		<cfquery name="data.query" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id, name, modified, deleted, description, siteid FROM contentGroups WHERE name = 'unittesting'
		</cfquery>
		
		<cfset asserttrue(condition=(data.query.recordcount EQ 1),message="Checking content group insert did not find record")>
		<cfset asserttrue(condition=(data.query.name EQ 'unittesting'),message="Checking content group record name value not eq to unittesting")>
		<cfset asserttrue(condition=(data.query.deleted EQ 0),message="Checking content group record deleted value not eq to 0")>
		<cfset asserttrue(condition=(data.query.description EQ "ut desc"),message="Checking content group record description value not eq to 'ut desc'")>
		<cfset assertfalse(condition=(data.query.siteid EQ ""),message="Checking content group record siteid value is blank")>
			
		<!--- check cgl records correct --->	
		<cfquery name="data.cglquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT cgl.id FROM contentGroupLocations cgl
			WHERE cgl.contentGroupId = <cfqueryparam value="#data.query.id#" cfsqltype="cf_sql_varchar"> 
				AND cgl.deleted = 0
		</cfquery>

		<cfset asserttrue(condition=(data.cglquery.recordcount EQ listlen(iT.fields['sitepages'])),message="Checking contentGroupLocations join table, did not find correct no of record")>
		
		<!--- check cgl records correct --->	
		<cfquery name="data.cguquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT cgu.id FROM contentGroupUsers cgu 
			INNER JOIN users u ON u.id = cgu.userid AND u.deleted = 0 AND u.active = 1
			WHERE cgu.contentGroupId = <cfqueryparam value="#data.query.id#" cfsqltype="cf_sql_varchar"> AND cgu.deleted = 0
		</cfquery>

		<cfset asserttrue(condition=(data.cguquery.recordcount EQ listlen(iT.fields['usersingroup'])),message="Checking content contentGroupUsers join table, did not find correct no of record")>
		
		<!--- check cg logs record correct --->	
		<cfquery name="data.cglogquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT COUNT(*) FROM activitylogs cgl
			INNER JOIN users u ON u.id = cgl.changedby AND description LIKE '%unitesting%' AND description LIKE '%inserted%'
			WHERE cgl.itemid = <cfqueryparam value="#data.query.id#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=(data.cglogquery.recordcount EQ 1),message="Checking content contentGroup logs. Did not find record of insert activity")>
		
		
		<!--- Testing Edit Content Group form /editContentGroup/ --->
		<cfset iT.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>

		<cfset iT.fields['id'] = iT.id>
		<cfset variables.httpObj.setPath("/ContentGroups/editContentGroup/")>
		<cfset variables.httpObj.clear('formfields,urlfields')>
		<cfset variables.httpObj.addUrlField('id', iT.fields['id'])>
		<cfset iT.fieldsBackup = duplicate(iT.fields)>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while displaying Edit Content Group form.")>
		
		<!--- Testing Save Existing Content Group -> Comparing 'fieldsback' query to 'input' query - Removing elements that will skew comparison. --->
		<cfset iT.fieldsOut = response.getESMFormStruct()>
		
		<!--- sort list fields so we can compare --->
		<cfset it.fieldsout.sitepages = listsort(it.fieldsout.sitepages,"text")>
		<cfset it.fields.sitepages = listsort(it.fields.sitepages,"text")>
		<cfset it.fieldsout.usersingroup = listsort(it.fieldsout.usersingroup,"text")>
		<cfset it.fields.usersingroup = listsort(it.fields.usersingroup,"text")>
		
		<cfset assertEquals(expected = iT.fieldsOut, actual = iT.fields, message="When saving Content Group, query 'in' is not equal to query 'out'.")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#iT.fieldsBackup#" item="iT.idx">
		<cfset variables.httpObj.addFormField(iT.idx, iT.fieldsBackup[iT.idx])>
		</cfloop>
		
        <!--- Testing Save Functionality for: Content Group /saveContentGroup/ --->
		<cfset variables.httpObj.setPath("/ContentGroups/saveContentGroup/")>
		
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while updating Content Group")>
		<cfset asserttrue(condition=(response.existsByPattern("Content Group Updated")),message="The system did not confirm the update.")>

		<!--- RESAVE WITH THE USERS BLANK SO AS NOT TO TRIP ERROR. --->
		<cfset variables.httpObj.addFormField("usersingroup", "")> 
		<cfset response = variables.httpObj.load()>
		
		<!--- Execute Prior to Delete Functionality - Clear Form Fields--->
		<cfset variables.httpObj.clear('formfields')>
		
		<!--- Testing Delete Functionality for: Content Group /deleteContentGroup/ --->
		<cfset variables.httpObj.setPath("/ContentGroups/deleteContentGroup/")>
		<cfset variables.httpObj.addUrlField('id', iT.id)>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while deleting Content Group.")>
		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		<cfset variables.httpObj.setPath("/ContentGroups/startPage/")>
		<cfset response = variables.httpObj.load()>
		<cfset iT.findid = response.getByPattern(replace(iT.id, "-", "\-","all"))>
		<cfset asserttrue(condition=(iT.findid EQ ""),message="The Content Group was not deleted.")>
		
		<!--- confirm all logs are written --->
		
		<!--- check log records correct --->	
		<cfquery name="data.cglogsquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%insert%" cfsqltype="cf_sql_varchar"> 
			AND itemid = <cfqueryparam value="#it.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		
		<cfset asserttrue(condition=(data.cglogsquery.recordcount EQ 1),message="Checking logs, did not find record of insert")>
		
		<!--- check cgl records correct --->	
		<cfquery name="data.cglogsquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%update%" cfsqltype="cf_sql_varchar"> 
			AND itemid = <cfqueryparam value="#it.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfset asserttrue(condition=(data.cglogsquery.recordcount EQ 2),message="Checking logs, did not find record of update")>
		
		<!--- check cgl records correct --->	
		<cfquery name="data.cglogsquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%delete%" cfsqltype="cf_sql_varchar"> 
			AND itemid = <cfqueryparam value="#it.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfset asserttrue(condition=(data.cglogsquery.recordcount EQ 1),message="Checking logs, did not find record of delete")>

	</cffunction>
	
</cfcomponent>