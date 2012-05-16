<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>
		
		<cfset var statesQ = createObject("component", "utilities.worldinfo").init(requestObject).getStates()>
		
		<cfset variables.forminfo.name = "newuserform">
		
		<cfset lcl.tbl = addItem("table")>
		<cfset lcl.tbl.setName("wraptable")>
		<cfset lcl.tbl.setLabel("Wrap Table")>
		
		<cfset lcl.tblrow = lcl.tbl.addItem("tablerow")>
		<cfset lcl.tblrow.setName("wraptablerow")>
		<cfset lcl.tblrow.setLabel("Wrap Table Row")>
		
		<cfset lcl.tblcol = lcl.tblrow.addItem("tablecolumn")>
		<cfset lcl.tblcol.setName("wraptablecolumn")>
		<cfset lcl.tblcol.setLabel("Wrap Table Col")>
		
		<cfset lcl.sectwrap = lcl.tblcol.addItem("section")>
		<cfset lcl.sectwrap.setName("credentials section")>
		<cfset lcl.sectwrap.setLabel("Your Credentials")>
		
		<cfset lcl.txt = lcl.sectwrap.addItem("Text")>
		<cfset lcl.txt.setName('fname')>
		<cfset lcl.txt.setLabel('First Name')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		
		<cfset lcl.txt = lcl.sectwrap.addItem("Text")>
		<cfset lcl.txt.setName('lname')>
		<cfset lcl.txt.setLabel('Last Name')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		
		<cfset lcl.txt = lcl.sectwrap.addItem("Text")>
		<cfset lcl.txt.setName('email')>
		<cfset lcl.txt.setLabel('Email')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		<cfset lcl.txt.addValidation("validemail")>
		
		<cfset lcl.txt = lcl.sectwrap.addItem("Text")>
		<cfset lcl.txt.setName('username')>
		<cfset lcl.txt.setLabel('Username')>
		<cfset lcl.txt.setformstyle("width","130px")>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxLength(20)>
		
		<cfset lcl.txt = lcl.sectwrap.addItem("password")>
		<cfset lcl.txt.setLabel('Password')>
		<cfset lcl.txt.setName('password')>
		<cfset lcl.txt.setformstyle("width","130px")>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxLength(20)>
				
		<cfset lcl.tblcol2 = lcl.tblrow.addItem("tablecolumn")>
		<cfset lcl.tblcol2.setName("addy section")>
		<cfset lcl.tblcol2.setLabel("Your Address")>
		
		<cfset lcl.addwrap = lcl.tblcol2.addItem("section")>
		<cfset lcl.addwrap.setName("addy section")>
		<cfset lcl.addwrap.setLabel("Your Address")>
		
		<cfset lcl.txt = lcl.addwrap.addItem("Text")>
		<cfset lcl.txt.setName('address1')>
		<cfset lcl.txt.setLabel('Address')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(100)>
		
		<cfset lcl.txt = lcl.addwrap.addItem("Text")>
		<cfset lcl.txt.setName('address2')>
		<cfset lcl.txt.setLabel('')>
		<cfset lcl.txt.maxlength(100)>

		<cfset lcl.txt = lcl.addwrap.addItem("Text")>
		<cfset lcl.txt.setName('city')>
		<cfset lcl.txt.setLabel('City')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(500)>
		
		<cfset lcl.data = structnew()>
		<cfset lcl.data.query = statesQ>
		<cfset lcl.data.labelsfield="name">
		<cfset lcl.data.valuesfield="abbrev">
		
		<cfset lcl.txt = lcl.addwrap.addItem("select")>
		<cfset lcl.txt.setName('state')>
		<cfset lcl.txt.setLabel('State')>
		<cfset lcl.txt.setData(lcl.data)>
		<cfset lcl.txt.setRequired()>
		
		<cfset lcl.txt = lcl.addwrap.addItem("Text")>
		<cfset lcl.txt.setName('postalcode')>
		<cfset lcl.txt.setLabel('Zip')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.addValidation("iszip")>
		
		<cfset lcl.txt = lcl.addwrap.addItem("Text")>
		<cfset lcl.txt.setName('phone')>
		<cfset lcl.txt.setLabel('Phone')>
		
		<cfset lcl.txt = lcl.addwrap.addItem("Text")>
		<cfset lcl.txt.setName('fax')>
		<cfset lcl.txt.setLabel('Fax')>
		
		<cfset lcl.sbm = addItem("submit")>
		<cfset lcl.sbm.setDefault('Create')>
		<cfset lcl.sbm.setName('loginbtn')>
		
	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
	
		<cfset var vdtr = super.validate(clear)>
		<cfset var lcl = structnew()>
		
		<cfset variables.clientobj = createObject("component","modules.users.models.users").init(requestObject)>
		<cfset lcl.vars = requestObject.getAllFormUrlVars()>

		<!--- check email not already taken --->
		<cfset lcl.emaildups = variables.clientobj.getByEmail(lcl.vars.email)>
		<cfif lcl.emaildups.recordcount>
			<cfset vdtr.addError("email", "This email is already in use. If its yours, and you can't access it, please contact us.  Otherwise, please choose another.")>
		</cfif>
		
		<!--- check user not already taken --->
		<cfset lcl.userdups = variables.clientobj.getByUsername(lcl.vars.username)>
		<cfif lcl.userdups.recordcount>
			<cfset vdtr.addError("username", "This Username is already in use.  Otherwise, please choose another.")>
		</cfif>
			
		<cfset lcl.vars.password = hash(lcl.vars.password)>
		<cfset structdelete(lcl.vars, "id")>
		<cfset structdelete(lcl.vars, "active")>
		
		<cfset lcl.vars.line1 = lcl.vars.address1>
		<cfset lcl.vars.line2 = lcl.vars.address2>
		
		<cfset variables.clientobj.setValues(lcl.vars)>
		
		<cfset lcl.vdtr2 = variables.clientobj.validateSave()>
		
		<cfset vdtr.merge(lcl.vdtr2)>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		
		<cfset lcl.vars = requestObject.getAllFormUrlVars()>
		
		<cfif NOT variables.clientObj.save()>
			<cfthrow message="not saved">
		</cfif>
		
		<cfset lcl.userObject = requestObject.getUserObject()>
		
		<!--- force login --->
		<cfset lcl.userObject.login(lcl.vars.username, lcl.vars.password, requestObject)>
		
		<cfset lcl.userinfo = variables.clientObj.getValues()>
		
		<cfset lcl.msg = createObject("component", "modules.messaging.models.messaging").init(requestObject)>
		<cfset lcl.msg.sendMessage(
			lcl.userinfo.email,
			"New Account",
			lcl.userinfo	
		)>
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.appendUrlVar = structnew()>
		<cfset s.appendUrlVar['successfully_create_account']=1>
		<cfset s.relocate = '/user/login'>
		<cfset s.message = "You have successfully created an account.">
		<cfreturn s>
	</cffunction>
</cfcomponent>