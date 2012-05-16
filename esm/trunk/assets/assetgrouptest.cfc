<cfcomponent displayname="assetTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM assetGroups WHERE name = 'unittesting'
		</cfquery>
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activitylogs WHERE description LIKE '%unittesting%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/Assets/ViewAssetGroups/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see Asset Groups")>
		
	<!--- testing add Assets Groups --->
		<cfset variables.httpObj.setPath('/Assets/AddAssetGroup/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>

		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add Assets Groups page")>
		
	<!--- testing save new Assets Groups --->
		
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
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Asset Group")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="validation did not find name error")>
		
		<cfset l.fields['name'] = "unittesting">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Asset Group")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find validation error")>
		
	<!--- test edit Assets Group form--->
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset l.fields['id'] = l.id>
		
		<cfset variables.httpObj.setPath("/Assets/editAssetGroup/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.fields['id'])>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit Asset Group form")>

	<!--- test save existing Asset Group --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>
		
		<cfloop list="itemdate,id,name" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="When saving Asset Group, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/Assets/saveAssetgroup/")>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating Asset Group")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find name error")>
		
	<!--- test deleting Asset Group --->
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/Assets/deleteAssetGroup/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting Asset Group")>

		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/Assets/ViewAssetGroups/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="Asset Group was not deleted")>
	</cffunction>
	
</cfcomponent>
		