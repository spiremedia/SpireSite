<cfcomponent name="loginform" extends="utilities.forms2">

	<cffunction name="make">
		<cfset var lcl = structnew()>
		
		<cfset variables.forminfo.name = "loginform">
		
		<cfset lcl.txt = addItem("Text")>
		<cfset lcl.txt.setName('username')>
		<cfset lcl.txt.setRequired()>
		<cfset lcl.txt.setLabel('Username')>
		<cfset lcl.txt.addValidation("notblank")>
		
		<cfset lcl.txt = addItem("password")>
		<cfset lcl.txt.setLabel('Password')>
		<cfset lcl.txt.setName('password')>
        <cfset lcl.txt.setRequired()>
		<cfset lcl.txt.addValidation("notblank")>
		
		<cfset lcl.sbm = addItem("submit")>
		<cfset lcl.sbm.setDefault('Login')>
		<cfset lcl.sbm.setName('loginbtn')>
		<cfset lcl.html = addItem("html")>
		<cfset lcl.html.setName('forgot')>
		<cfset lcl.html.setHTML('<Br><a style="position:relative;top:-1.6em;left:-5px" href="/user/forgot">I forgot my info!</a>')>

	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
		<cfset var vdtr = super.validate(clear)>
		<cfset var lcl = structnew()>
		<cfset lcl.userObject = requestObject.getUserObject()>

		<cfset lcl.username = requestObject.getFormUrlvar("username")>
		<cfset lcl.password = requestObject.getFormUrlvar("password")>
		
		<cfif NOT lcl.userObject.login(lcl.username, lcl.password, requestObject)>
			<cfset vdtr.addError("userinfo", "Invalid credentials")>
		</cfif>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="submit">
		<cfargument name="vdtr" required="true">
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="onsuccessinfo">
		<cfset var s = structnew()>
		<cfset s.relocate = '/user'>
		<cfset s.message = "You have successfully logged in!">
		<cfreturn s>
	</cffunction>
	
</cfcomponent>