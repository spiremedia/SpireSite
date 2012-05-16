<cfcomponent displayname="galleryGroupModelTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM videos WHERE name = 'unittesting'
		</cfquery>
		<cfquery datasource="#request.requestObject.getVar("dsn")#">
			DELETE
			FROM activitylogs
			WHERE description LIKE '%unittesting%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/Videos/startPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see Videos")>
		
	<!--- testing add Videos --->
		<cfset variables.httpObj.setPath('/Videos/AddVideo/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>

		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add Videos page")>
		
	<!--- testing save new Videos --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['id'] = "">
		<cfset l.fields['name'] = "">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Video")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="validation did not find name error")>
		
		<cfset l.fields['name'] = "unittesting">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Video")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find validation error")>
		
		<!--- check database to see if its there --->
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT *
			FROM videos
			WHERE name = <cfqueryparam value="#l.fields['name']#" cfsqltype="cf_sql_varchar">
			AND deleted = 0
		</cfquery>

		<cfset asserttrue(condition=l.q.recordcount EQ 1, message="No records found after insert")>
		
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM activitylogs
			WHERE description LIKE <cfqueryparam value="%#l.fields['name']#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset asserttrue(condition=l.q.cnt EQ 1, message="query did not trigger observer to log. log is blank.")>
		
	<!--- test edit Videos form--->
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset l.fields['id'] = l.id>
		
		<cfset variables.httpObj.setPath("/Videos/EditVideo/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.fields['id'])>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit Video form")>

	<!--- test save existing Video --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>

		<cfloop list="id,name" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="When saving Video, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/Videos/saveVideo/")>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating Video")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find title error")>
		
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM activitylogs
			WHERE description LIKE <cfqueryparam value="%unittesting%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=l.q.cnt EQ 2, message="query did not trigger observer to log on update.")>
		
	<!--- test deleting Video --->
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/Videos/deleteVideo/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting Video")>

		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/Videos/startPage/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="Video was not deleted")>
		
		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM videos
			WHERE name = <cfqueryparam value="unittesting" cfsqltype="cf_sql_varchar">
			AND deleted = 0
		</cfquery>

		<cfset asserttrue(condition=l.q.cnt EQ 0, message="delete action did not remove record.")>

		<cfquery name="l.q" datasource="#request.requestObject.getVar("dsn")#">
			SELECT count(*) cnt
			FROM activitylogs
			WHERE description LIKE <cfqueryparam value="%unittesting%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=l.q.cnt EQ 3, message="delete action did not trigger observer to log log is blank on delete.")>

    </cffunction>
    
</cfcomponent>