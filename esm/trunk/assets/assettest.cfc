<cfcomponent displayname="assetTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
		
		<cfset variables.assetgroupid = createuuid()>
		
		<!--- insert assetgroup, asset --->
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			INSERT INTO assetGroups (id,name,modified,deleted,description,changedby)
			VALUES (
				<cfqueryparam value="#variables.assetgroupid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="Asset Group - Unit Test" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="Asset Group - Unit Test" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="8C8DD7E6-EA08-57D6-6556D3BB74048D54" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM assets WHERE name = 'unittesting'
		</cfquery>
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM assetGroups WHERE id = <cfqueryparam value="#variables.assetgroupid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activitylogs WHERE description LIKE '%unittesting%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/Assets/startPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see Assets")>
		
	<!--- testing add Assets --->
		<cfset variables.httpObj.setPath('/Assets/AddAsset/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>

		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add Assets page")>
		
	<!--- testing save new Assets --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['id'] = "">
		<cfset l.fields['name'] = "">
		<cfset l.fields['assetgroupid'] = "">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Asset")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""name""")),message="validation did not find name error")>
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""assetgroupid""")),message="validation did not find assetgroupid error")>
		
		<cfset l.fields['name'] = "unittesting">
		<cfset l.fields['assetgroupid'] = variables.assetgroupid>
		<cfset l.fields['startdate'] = "02/21/2009">
		<cfset l.fields['enddate'] = "02/21/2009">
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new Asset")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find validation error")>
		
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		
		<!--- new cf9 bug test --->
		<cfset variables.httpObj.setPath('/Assets/AddAsset/')>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern("editAsset\/\?id\=#l.id#")),message="did not find correct edit link to newly created Asset in the Browse Tab.")>
		
		
	<!--- test edit Assets form--->
		<cfset l.fields['id'] = l.id>
		
		<cfset variables.httpObj.setPath("/Assets/EditAsset/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.fields['id'])>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit Asset form")>

	<!--- test save existing Asset --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>

		<cfloop list="itemdate,id,name" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="When saving Asset, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/Assets/saveAsset/")>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating Asset")>
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find title error")>
		
	<!--- test deleting Asset --->
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/Assets/deleteAsset/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting Asset")>

		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/Assets/startPage/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="Asset was not deleted")>
	</cffunction>
	
</cfcomponent>
		