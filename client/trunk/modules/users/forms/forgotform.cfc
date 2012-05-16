<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>
		
		<cfset variables.forminfo.name = "forgotform">
		
		<cfset lcl.txt = addItem("html")>
		<cfset lcl.txt.setName("comments")>
		<cfset lcl.txt.setHTML("Fill in this form and we will email you your password.  Once you receive it, please relogin and update it.<BR><BR>")>
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('email')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.setLabel('Your email')>
		<!---<cfset lcl.txt.setFormStyle("width","130px")>--->
		<cfset lcl.txt.addValidation("notblank")>
		
		<cfset lcl.sbm = addItem("submit")>
		<cfset lcl.sbm.setDefault('Send me my info')>
		<cfset lcl.sbm.setName('forgotsubmit')>

	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
		<cfset var vdtr = super.validate(clear)>
		<cfset var lcl = structnew()>
		
		<cfset variables.userObj = createObject("component","modules.users.models.users").init(requestObject)>
	
		<cfset lcl.s = structnew()>
		<cfset lcl.s.email = requestObject.getFormUrlvar("email")>

		<cfset variables.userfound = variables.userObj.getByEmail(lcl.s.email)>
		
		<cfif variables.userfound.recordcount EQ 0>
			<cfset vdtr.addError("email", "We could not find your account. Please check the spelling of your email and resubmit or call us at the contact information given below.")>
		</cfif>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var newpwd = right(createuuid(),10)>
		
		<cfset variables.userObj.setId(variables.userfound.id)>
		<cfset variables.userObj.setPassword(hash(newpwd))>
		<cfset variables.userObj.save()>
		<cfset variables.userfound.password[1] = newpwd>
		
		<cfset lcl.msg = createObject("component", "modules.messaging.models.messaging").init(requestObject)>
		<cfset lcl.msg.sendMessage(
			variables.userfound.email,
			"Lost Password",
			variables.userfound	
		)>
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.relocate = '/user/login'>
		<cfset s.message = "Your information has been sent to you. Check your email and log back in to update your password.">
		<cfreturn s>
	</cffunction>
	
</cfcomponent>