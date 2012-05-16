<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>
		<cfset var statesQ = createObject("component", "utilities.worldinfo").init(requestObject).getStates()>
		<cfset variables.userid = requestObject.getUserObject().getUserId()>
		<cfset variables.clientobj = createObject("component","modules.users.models.users").init(requestObject)>
		<cfset variables.clientObj.load(variables.userid)>
		
		<cfset variables.forminfo.name = "updateuserform">
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('fname')>
		<cfset lcl.txt.setLabel('First Name')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		<cfset lcl.txt.setDefault(variables.clientObj.getFName())>
		
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('lname')>
		<cfset lcl.txt.setLabel('Last Name')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		<cfset lcl.txt.setDefault(variables.clientObj.getLName())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('birthday')>
		<cfset lcl.txt.setLabel('Birthday (MM/DD/YYYY)')>
		<cfset lcl.txt.setDefault(dateformat(variables.clientObj.getBirthday(),"mm/dd/yyyy"))>
		<cfset lcl.txt.setRequired()>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('line1')>
		<cfset lcl.txt.setLabel('Address')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(100)>
		<cfset lcl.txt.setDefault(variables.clientObj.getLine1())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('line2')>
		<cfset lcl.txt.setLabel('')>
		<cfset lcl.txt.maxlength(100)>
		<cfset lcl.txt.setDefault(variables.clientObj.getLine2())>

		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('city')>
		<cfset lcl.txt.setLabel('City')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(500)>
		<cfset lcl.txt.setDefault(variables.clientObj.getCity())>
		
		<cfset lcl.txt = addItem("select")>
		<cfset lcl.txt.setName('state')>
		<cfset lcl.txt.setLabel('State')>
		<cfset lcl.txt.setRequired()>

		<cfset lcl.data = structnew()>
		<cfset lcl.data.query = statesQ>
		<cfset lcl.data.labelsfield="name">
		<cfset lcl.data.valuesfield="abbrev">
		<cfset lcl.txt.setData(lcl.data)>
		<cfset lcl.txt.setDefault(variables.clientObj.getState())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('postalcode')>
		<cfset lcl.txt.setLabel('Zip')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.addValidation("iszip")>
		<cfset lcl.txt.setDefault(variables.clientObj.getPostalCode())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('email')>
		<cfset lcl.txt.setLabel('Email')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.maxlength(40)>
		<cfset lcl.txt.addValidation("validemail")>
		<cfset lcl.txt.setDefault(variables.clientObj.getEmail())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('homephone')>
		<cfset lcl.txt.setLabel('Home Phone')>
		<cfset lcl.txt.setDefault(variables.clientObj.getHomePhone())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('mobilephone')>
		<cfset lcl.txt.setLabel('Cell Phone')>
		<cfset lcl.txt.setDefault(variables.clientObj.getMobilePhone())>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('fax')>
		<cfset lcl.txt.setLabel('Fax')>
		<cfset lcl.txt.setDefault(variables.clientObj.getFax())>

		<cfset lcl.sbm = addItem("submit")>
		<cfset lcl.sbm.setDefault('Update')>
		<cfset lcl.sbm.setName('updatebtn')>

	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
	
		<cfset var vdtr = super.validate(clear)>

		
		<cfset variables.clientobj = createObject("component","modules.users.models.users").init(requestObject)>
		<cfset variables.vars = requestObject.getAllFormUrlVars()>

		<!--- check email not already taken --->
		<cfset lcl.emaildups = variables.clientobj.getByEmail(variables.vars.email)>
		<cfif lcl.emaildups.recordcount AND lcl.emaildups.email NEQ variables.vars.email>
			<cfset vdtr.addError("email", "EDITThis email is already in use by another user. Otherwise, please choose another.")>
		</cfif>
		
		<!--- check username already used
		<cfset lcl.usernamedups = variables.clientobj.getByUsername(lcl.vars.username)>
		<cfif lcl.emaildups.recordcount AND lcl.emaildups.username NEQ lcl.vars.username>
			<cfset vdtr.addError("username", "This username is already in use by another user. Please choose another.")>
		</cfif> --->

		<cfset variables.vars.id = variables.userid>
		
		<cfset structdelete(variables.vars, "active")>
		<cfset structdelete(variables.vars, "password")>

		<cfset variables.clientobj.setValues(variables.vars)>
		
		<cfset lcl.vdtr2 = variables.clientobj.validateSave()>
		
		<cfset vdtr.merge(lcl.vdtr2)>	
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		<cfif NOT variables.clientObj.save()>
			<cfthrow message="not saved">
		</cfif>
		
		<cfset lcl.msg = createObject("component", "modules.messaging.models.messaging").init(requestObject)>
		<cfset lcl.msg.sendMessage(
			variables.clientObj.getEmail(),
			"Changed Account",
			variables.vars	
		)> 
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.relocate = "/user">
		<cfset s.message = "You have successfully updated your account.">
		<cfreturn s>
	</cffunction>
</cfcomponent>