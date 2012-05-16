<cfcomponent displayname="videoGalleryGroupModelTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
		
		<cfset variables.videoid = createuuid()>
		
		<!--- insert Videogroup, Video --->
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			INSERT INTO videos (id,name,title,created,deleted,changedby)
			VALUES (
				<cfqueryparam value="#variables.videoid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="unittestingvideos" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="unittestingvideos" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="8C8DD7E6-EA08-57D6-6556D3BB74048D54" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM videogroups WHERE name = 'unittestingvideos'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM videos WHERE name = 'unittestingvideos'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM videostovideogroups WHERE videoid = <cfqueryparam value="#variables.videoid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activitylogs WHERE description LIKE '%unittestingvideos%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/Videos/ViewVideoGroups/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see Video Groups")>
		
	<!--- testing add Videos Groups --->
		<cfset variables.httpObj.setPath('/Videos/AddVideoGroup/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>

		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add Video Groups page")>
		
	<!--- testing save new Videos Groups --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['id'] = "">
		<cfset l.fields['name'] = "">
		<cfset l.fields['videoids'] = "">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Video Group")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="validation did not find name error")>
		
		<cfset l.fields['name'] = "unittestingvideos">
		<cfset l.fields['videoids'] = variables.videoid>
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Video Group")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find validation error")>
		
		<!--- check database to see if its there --->
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT *
			FROM videogroups
			WHERE name = <cfqueryparam value="#l.fields['name']#" cfsqltype="cf_sql_varchar">
			AND deleted = 0
		</cfquery>

		<cfset asserttrue(condition=l.q.recordcount EQ 1, message="No records found after insert")>
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfif l.idx NEQ "id" AND l.idx NEQ "videoids">
				<cfset asserttrue(condition=(l.q[l.idx][1] NEQ ""), message="query did not enter all data ""#l.idx#"" is blank.")>
			</cfif>
		</cfloop>
		
		<!--- check database to see if its there --->
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT *
			FROM videostovideogroups
			WHERE videoid = <cfqueryparam value="#variables.videoid#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=l.q.recordcount EQ 1, message="No records found after insert")>
		
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%#l.fields['name']#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset asserttrue(condition=l.q.cnt EQ 1, message="query did not trigger observer to log log is blank.")>
		
	<!--- test edit Videos Group form--->
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset l.fields['id'] = l.id>
		
		<cfset variables.httpObj.setPath("/Videos/editVideoGroup/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.fields['id'])>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit Video Group form")>

	<!--- test save existing Video Group --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>
		
		<cfloop list="itemdate,id,name" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="When saving Video Group, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/Videos/saveVideogroup/")>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating Video Group")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find name error")>
		
	<!--- test deleting Video Group --->
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/Videos/deleteVideoGroup/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting Video Group")>

		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/Videos/ViewVideoGroups/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="Video Group was not deleted")>
		
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM videogroups
			WHERE name = <cfqueryparam value="unittestingvideos" cfsqltype="cf_sql_varchar">
			AND deleted = 0
		</cfquery>

		<cfset asserttrue(condition=l.q.cnt EQ 0, message="delete action did not remove record.")>

		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM activitylogs
			WHERE description LIKE <cfqueryparam value="%unittestingvideos%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=l.q.cnt EQ 3, message="delete action did not trigger observer to log log is blank on delete.")>
    </cffunction>
    
</cfcomponent>