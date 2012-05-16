<cfcomponent displayname="loginTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM users WHERE username like '%gazook%'
		</cfquery>

		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM activityLogs WHERE description like '%gazook%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
		<cfset var data = structnew()>
				
		<cfset variables.httpObj.setPath('/Users/StartPage/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see users")>
		
		
		<!--- testing add user --->
		<cfset variables.httpObj.setPath('/Users/AddUser/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>
		
		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add page")>
		
		<!--- testing save new user --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['country'] = 'USA'>
		<cfset l.fields['id'] = ''>
		
		<cfset l.fields['line1'] = 'myline1'>
		<cfset l.fields['postalcode'] = '58000'>
		<cfset l.fields['state'] = "CO">
		<cfset l.fields['active'] = 1>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new user")>
		
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""password""")),message="validation did not find password error")>
		<cfset asserttrue(condition=(response.existsByPattern("valid email")),message="validation did not find valid email error")>

		<cfset l.pwd = "gazook#randrange(340,1000)#@lklklk#randrange(340,1000)#.com">
		<cfset variables.httpObj.addFormField('username', l.pwd)>
		<cfset variables.httpObj.addFormField('password', left(l.fields['password'],10) )>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new user")>
		
		<cfset asserttrue(condition=(response.existsByPattern("""user added")),message="Did not confirm that a user was added")>
		
		<!--- test edit user form--->
		
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>

		<cfset variables.httpObj.setPath("/users/editUser/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit user form")>

		<!--- test saveed existing user --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>

		<cfloop list="password,activeold,id,username" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="after inserting user, get form, details are not same as went in")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>

		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		<cfset variables.httpObj.addFormField("id", l.id)>
		<cfset variables.httpObj.addFormField("password", "")>
		<cfset variables.httpObj.addFormField("username", l.pwd)>
		
		<cfset variables.httpObj.setPath("/users/saveUser/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating user")>
		<cfset assertfalse(condition=(response.existsByPattern("""VALIDATION""")),message="Problem saving, validation caught something.")>
		<cfset asserttrue(condition=(response.existsByPattern("""user saved""")),message="Did not confirm save correctly.")>
		<!--- test deleting user --->
		
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/users/deleteUser/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting user")>
		
		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/users/startPage/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="user was not deleted")>
		
		<!--- check cgl records correct --->	
		<cfquery name="data.userlogsquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%insert%" cfsqltype="cf_sql_varchar"> 
				AND itemid = <cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfset asserttrue(condition=(data.userlogsquery.recordcount EQ 1),message="Checking user logs, did not find record of insert")>
		
		<!--- check cgl records correct --->	
		<cfquery name="data.userlogsquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%update%" cfsqltype="cf_sql_varchar"> 
				AND itemid = <cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfset asserttrue(condition=(data.userlogsquery.recordcount EQ 1),message="Checking user logs, did not find record of update")>
		
		<!--- check cgl records correct --->	
		<cfquery name="data.userlogsquery" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM activityLogs
			WHERE description LIKE <cfqueryparam value="%delete%" cfsqltype="cf_sql_varchar"> 
				AND itemid = <cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfset asserttrue(condition=(data.userlogsquery.recordcount EQ 1),message="Checking user logs, did not find record of delete")>

		<!--- check user correctly deleted records correct --->	
		<cfquery name="data.userisdeleted" datasource="#request.requestObject.getVar('dsn')#">
			SELECT id FROM users
			WHERE deleted = 1
				AND id = <cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfset asserttrue(condition=(data.userlogsquery.recordcount EQ 1),message="User not findable by id and deleted = 1")>
		
	</cffunction>
    
</cfcomponent>