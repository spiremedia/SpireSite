<cfcomponent displayname="newsitemTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM newsItems WHERE name = 'unittesting'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/News/startPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see news items")>
		
		<!--- testing add news items --->
		<cfset variables.httpObj.setPath('/News/AddNews/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>

		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add news items page")>
		
		<!--- testing save new news items --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['id'] = "">
		<cfset l.fields['name'] = "">
		<cfset l.fields['description'] = "">
		<cfset l.fields['title'] = "">
		<cfset l.fields['itemdate'] = "">
		<cfset l.fields['startdate'] = "">
		<cfset l.fields['enddate'] = "">
		<cfset l.fields['assetid'] = "">
		<cfset l.fields['linkpageid'] = "">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new news item")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="validation did not find name error")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""title""")),message="validation did not find title error")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""itemdate""")),message="validation did not find itemdate error")>

		<cfset l.fields['name'] = "unittesting">
		<cfset l.fields['title'] = "unittesting">
		<cfset l.fields['description'] = "unittestingdesc">
		<cfset l.fields['htmlText'] = "unittestinghtmltext">
		<cfset l.fields['itemdate'] = "02/21/2009">
		<cfset l.fields['startdate'] = "02/21/2009">
		<cfset l.fields['enddate'] = "02/21/2009">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new news item")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find name error")>
		
		<!--- test edit news items form--->
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset l.fields['id'] = l.id>
		
		<cfset variables.httpObj.setPath("/News/editNews/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.fields['id'])>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit news item form")>

		<!--- test save existing news item --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>
		
		<!--- <cfloop list="itemdate,id,name,description" index="l.ldelidx"> --->
		<cfloop list="itemdate,id,name" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="When saving news item, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/News/saveNews/")>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating news item")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find name error")>
		
		<!--- test deleting news item --->
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/News/deleteNews/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting news item")>

		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/News/startPage/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="news item was not deleted")>
		
	</cffunction>
	
</cfcomponent>
		