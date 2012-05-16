<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>
		
		<cfset variables.forminfo.name = "updatepasswordform">
		
		<cfset lcl.txt = addItem("html")>
		<cfset lcl.txt.setName("comments")>
		<cfset lcl.txt.setHTML("Enter your password here to udpate it.<br><br>")>
		
		<cfset lcl.txt = addItem("password")>
		<cfset lcl.txt.setName('password')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.setLabel('Your new password')>
		<cfset lcl.txt.addClassToForm("width","130px")>

		
		<cfset lcl.txt = addItem("password")>
		<cfset lcl.txt.setName('password2')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.setLabel('Password Repeat')>
		<cfset lcl.txt.addClassToForm("width","130px")>

		
		<cfset lcl.sbm = addItem("submit")>
		<cfset lcl.sbm.setDefault('Update Password')>
		<cfset lcl.sbm.setName('updatepassword')>

	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
		<cfset var vdtr = super.validate(clear)>
		<cfset var lcl = structnew()>
	
		<cfset variables.pwd1 = trim(requestObject.getFormUrlvar("password"))>
		<cfset variables.pwd2 = trim(requestObject.getFormUrlvar("password2"))>

		<cfif len(variables.pwd1) LT 5 OR len(variables.pwd1) GT 12 >
			<cfset vdtr.addError("password", "The new password must be between 5 and 12 chars long.")>
		</cfif>

		<cfif variables.pwd1 NEQ variables.pwd2>
			<cfset vdtr.addError("password2", "The two passwords do not match. Please retype them.")>
		</cfif>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		<cfset var lcl = structnew()>
		
		<cfset var newpwd = variables.pwd1>
		<cfset variables.userObj = createObject("component","modules.users.models.users").init(requestObject)>
		<cfset variables.userObj.load(requestObject.getUserObject().getUserId())>
		<cfset variables.userObj.setPassword(hash(newpwd))>
		<cfset variables.userObj.save()>
				
		<cfset lcl.msg = createObject("component", "modules.messaging.models.messaging").init(requestObject)>
		<cfset lcl.msg.sendMessage(
			variables.userObj.getEmail(),
			"Password Updated",
			variables.userObj.getAll()
		)>
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.relocate = '/user'>
		<cfset s.message = "Your password has been successfully updated.">
		<cfreturn s>
	</cffunction>
	
</cfcomponent>