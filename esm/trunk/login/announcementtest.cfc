<cfcomponent displayname="loginTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM announcements WHERE name = 'unittesting'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activitylogs WHERE description LIKE '%unittesting%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/login/startPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see announcements")>
		
	<!--- testing add announcement --->
		<cfset variables.httpObj.setPath('/login/AddAnnouncement/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>

		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add announcements page")>
		
	<!--- testing save new announcement --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['name'] = "">
		<cfset l.fields['itemdate'] = "">
		<cfset l.fields['id'] = "">
		<cfset l.fields['active'] = 1>
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new announcement")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="validation did not find title error")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""itemdate""")),message="validation did not find display date error")>

		<cfset l.fields['name'] = "unittesting">
		<cfset l.fields['itemdate'] = "02/21/2009">
		<cfset variables.httpObj.addFormField('name', l.fields['name'])>
		<cfset variables.httpObj.addFormField('itemdate', l.fields['itemdate'])>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new announcement")>
		
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find title error")>
		
	<!--- test edit announcements form--->
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset l.fields['id'] = l.id>
		
		<cfset variables.httpObj.setPath("/Login/EditAnnouncement/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.fields['id'])>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit announcement form")>

	<!--- test save existing announcement --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>
		
		<cfloop list="itemdate,id,name" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = structsort(l.fieldsOut), actual = structsort(l.fields), message="When saving announcement, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/login/saveAnnouncement/")>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating announcement")>
		
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find title error")>
		
	<!--- test deleting announcement --->
		
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/login/deleteAnnouncement/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting announcement")>
		
		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/login/startPage/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="announcement was not deleted")>
	</cffunction>
	
</cfcomponent>
		