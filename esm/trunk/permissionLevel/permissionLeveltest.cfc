<cfcomponent displayname="PermissionLevelTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset teardown()>
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset d = structnew()>
		<cfquery name="d.cg" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM permissionLevels WHERE name = 'unittesting'
		</cfquery>

		<cfloop query="d.cg">
			<cfquery name="recordcgRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM permissionLevels WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="recordcguRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM permissionLevelsToUsers WHERE permissionLevelid = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="recordcguRemove" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM permissionLevelItems WHERE permissionLevelid = <cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
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
		<cfset variables.httpObj.setPath('/PermissionLevel/startPage/')>
		<cfset response = variables.httpObj.load()>
		<cfset assertfalse(condition=(response.is302relocate()),message="User 'sa' logged in.  Unable to see Permission Levels.")>
		
		<!--- Testing Add Permission Levels /AddPermissionLevel/ --->
		<cfset variables.httpObj.setPath('/PermissionLevel/AddPermissionLevel/')>
		<cfset response = variables.httpObj.load()>
		<cfset iT.formFields = response.getESMFormFields()>
		<cfset assertfalse(condition=(len(iT.formFields) EQ 0),message="There are no form fields on the Add Permission Levels page.")>
		
		<!--- Testing Save Functionality for New Permission Levels --->
		<cfset iT.submitsto = response.getESMSubmitsTo()>
		<cfset variables.httpObj.setPath(iT.submitsto)>
		<cfset variables.httpObj.clear('formfield,urlfields')>
		<cfset iT.fields = structnew()>
		
		<cfloop list="#iT.formfields#" index="iT.idx">
			<cfset iT.fields[iT.idx] = "">
		</cfloop>
		
     	<cfset iT.fields['id'] = "">     
		<cfset iT.fields['name'] = "">
		<cfset iT.fields['Description'] = "">
		
		<cfloop collection="#iT.fields#" item="iT.idx">
			<cfset variables.httpObj.addFormField(iT.idx, iT.fields[iT.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error while saving new Permission Levels.")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="The validation function did not find form field: name.")>
             
		<cfset iT.fields['name'] = "unittesting">
		<cfset iT.fields['description'] = "ut desc">
		
		<!--- get some users --->
		<cfquery name="data.getsomeusersquery" datasource="#request.requestObject.getVar('dsn')#">
		SELECT top 2 id FROM users WHERE deleted = 0 AND active = 1
		</cfquery>
		<cfset iT.fields['userids'] = valuelist(data.getsomeusersquery.id)>
		
		<!--- add some permission level items --->
		<cfset iT.fields['Users_items'] = "View,Add_User">
		
		<cfloop collection="#iT.fields#" item="iT.idx">
		<cfset variables.httpObj.addFormField(iT.idx, iT.fields[iT.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while saving new Permission Levels.")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="The validation function did not validate form field: name.")>
		<cfset asserttrue(condition=(response.existsByPattern("permission level added")),message="The system did not confirm that the item was added")>

		<!--- check permission level record correct --->
		<cfquery name="data.query" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id, name, modified, deleted, description, siteid FROM permissionLevels WHERE name = 'unittesting'
		</cfquery>
		
		<cfset asserttrue(condition=(data.query.recordcount EQ 1),message="Checking permission level insert did not find record")>
		<cfset asserttrue(condition=(data.query.name EQ 'unittesting'),message="Checking permission level record name value not eq to unittesting")>
		<cfset asserttrue(condition=(data.query.deleted EQ 0),message="Checking permission level record deleted value not eq to 0")>
		<cfset asserttrue(condition=(data.query.description EQ "ut desc"),message="Checking permission level record description value not eq to 'ut desc'")>
		<cfset assertfalse(condition=(data.query.siteid EQ ""),message="Checking permission level record siteid value is blank")>
			
		<!--- check permission level items records correct --->	
		<cfquery name="data.cglquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT pli.id FROM permissionLevelItems pli
			WHERE pli.permissionLevelid = <cfqueryparam value="#data.query.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfset asserttrue(condition=(data.cglquery.recordcount EQ listlen(iT.fields['Users_items'])),message="Checking permissionLevelItems join table, did not find correct no of record")>
		
		<!--- check permission level users records correct --->	
		<cfquery name="data.cguquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT plu.id FROM permissionLevelsToUsers plu 
			INNER JOIN users u ON u.id = plu.userid AND u.deleted = 0 AND u.active = 1
			WHERE plu.permissionLevelid = <cfqueryparam value="#data.query.id#" cfsqltype="cf_sql_varchar"> AND plu.deleted = 0
		</cfquery>

		<cfset asserttrue(condition=(data.cguquery.recordcount EQ listlen(iT.fields['userids'])),message="Checking permissionLevelsToUsers join table, did not find correct no of record")>
		
		<!--- check cg logs record correct --->	
		<cfquery name="data.cglogquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT COUNT(*) FROM activitylogs cgl
			INNER JOIN users u ON u.id = cgl.changedby AND description LIKE '%unitesting%' AND description LIKE '%inserted%'
			WHERE cgl.itemid = <cfqueryparam value="#data.query.id#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=(data.cglogquery.recordcount EQ 1),message="Checking content permissionLevels logs. Did not find record of insert activity")>
		
		<!--- Testing Edit Permission Levels form /editPermissionLevel/ --->
		<cfset iT.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>

		<cfset iT.fields['id'] = iT.id>
		<cfset variables.httpObj.setPath("/PermissionLevel/editPermissionLevel/")>
		<cfset variables.httpObj.clear('formfields,urlfields')>
		<cfset variables.httpObj.addUrlField('id', iT.fields['id'])>
		<cfset iT.fieldsBackup = duplicate(iT.fields)>
		<cfset response = variables.httpObj.load()>
        <cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while displaying Edit Permission Levels form.")>
		
		<!--- Testing Save Existing Permission Levels -> Comparing 'fieldsback' query to 'input' query - Removing elements that will skew comparison. --->
		<cfset iT.fieldsOut = response.getESMFormStruct()>
		
		<!--- sort list fields so we can compare --->
		<cfset it.fieldsout.Users_items = listsort(it.fieldsout.Users_items,"text")>
		<cfset it.fields.Users_items = listsort(it.fields.Users_items,"text")>
		<cfset it.fieldsout.userids = listsort(it.fieldsout.userids,"text")>
		<cfset it.fields.userids = listsort(it.fields.userids,"text")>
		
		<cfset assertEquals(expected = iT.fieldsOut, actual = iT.fields, message="When saving Permission Levels, query 'in' is not equal to query 'out'.")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#iT.fieldsBackup#" item="iT.idx">
			<cfset variables.httpObj.addFormField(iT.idx, iT.fieldsBackup[iT.idx])>
		</cfloop>
		
        <!--- Testing Save Functionality for: Permission Levels /savePermissionLevel/ --->
		<cfset variables.httpObj.setPath("/PermissionLevel/savePermissionLevel/")>
		
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while updating Permission Levels")>
		<cfset asserttrue(condition=(response.existsByPattern("Permission Level Updated")),message="The system did not confirm the update.")>

		<!--- RESAVE WITH THE USERS BLANK SO AS NOT TO TRIP ERROR. --->
		<cfset variables.httpObj.addFormField("usersingroup", "")> 
		<cfset response = variables.httpObj.load()>
		
		<!--- Execute Prior to Delete Functionality - Clear Form Fields--->
		<cfset variables.httpObj.clear('formfields')>
		
        <!--- Testing Delete Functionality for: Permission Levels /deletePermissionLevel/ --->
		<cfset variables.httpObj.setPath("/PermissionLevel/deletePermissionLevel/")>
		<cfset variables.httpObj.addUrlField('id', iT.id)>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="An error occured while deleting Permission Level.")>
		
		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		<cfset variables.httpObj.setPath("/PermissionLevel/startPage/")>
		<cfset response = variables.httpObj.load()>
		<cfset iT.findid = response.getByPattern(replace(iT.id, "-", "\-","all"))>
		<cfset asserttrue(condition=(iT.findid EQ ""),message="The Permission Level was not deleted.")>
		
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