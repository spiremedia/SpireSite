<cfcomponent name="defaultuser" output="False" extends="resources.abstractmodel">
	
	<cffunction name="init" output="False">
		<cfset variables.info = structnew()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getUserID" output="False">
		<cfreturn variables.info.id>
	</cffunction>
	
	<cffunction name="getUsername" output="False">
		<cfreturn variables.info.username>
	</cffunction>

	<cffunction name="getFirstName" output="False">
		<cfreturn variables.info.fname>
	</cffunction>

	<cffunction name="getEmail" output="False">
		<cfreturn variables.info.email>
	</cffunction>
	
	<cffunction name="getLastName" output="False">
		<cfreturn variables.info.lname>
	</cffunction>
	
	<cffunction name="getFullName" output="False">
		<cfreturn variables.info.fname & ' ' & variables.info.lname>
	</cffunction>
	
	<cffunction name="setFlash" output="False">
		<cfargument name="flash" required="true">
		<cfparam name="variables.flash" default = "#arraynew(1)#">
		<cfset arrayappend(variables.flash, arguments.flash)>
	</cffunction>
	
	<cffunction name="getFlash" output="False">
		<cfset var s = "">
		<cfparam name="variables.flash" default = "#arraynew(1)#">
		<cfset s = arraytolist(variables.flash, "<br/>")>
		<cfset arrayclear(variables.flash)>
		<cfreturn s>
	</cffunction>
	
	<cffunction name="clearFlash" output="False">
		<cfset variables.flash = arraynew(1)>
	</cffunction>
	
	<cffunction name="dump" output="False">
		dump in user
		<cfdump var=#variables#>
		<cfabort>
	</cffunction>
	
	<cffunction name="relogin" output="False">
		<cfargument name="reason" default="">
		<cfargument name="view" default="normal">
		
		<cfset logout()>
		
		<cfif arguments.view EQ 'normal'>
			<cflocation url="/Users/Login/?logout&reason=#reason#" addtoken="no">
		<cfelse>
			<cfcontent reset="true">relogin<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="login" output="False">
		<cfargument name="username" required="true">
		<cfargument name="password" required="true">
		<cfargument name="requestObject" required="true">
		
		<cfset var lcl = structnew()>
		<cfset password = hash(password)>
		
		<cfset lcl.userObj = createObject("component","modules.users.models.users").init(requestObject)>
	
		<cfset lcl.s = structnew()>
		<cfset lcl.s.password = password>

		<cfset lcl.userrs = lcl.userObj.getByUsername(username, lcl.s)>
		
		<cfif lcl.userrs.recordcount>
			<cfloop list="#lcl.userrs.columnlist#" index="lcl.idx">
				<cfset variables.info[lcl.idx] = lcl.userrs[lcl.idx][1]>
			</cfloop>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
		
	</cffunction>
	
	<cffunction name="logout">
		<cfset structdelete(variables.info,'id')>
	</cffunction>
	
	<cffunction name="isloggedin" output="False">
				
		<cfif structkeyexists(variables.info, 'id') 
				AND variables.info.id NEQ "">
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="saveData">
		<cfargument name="name" required="true">
		<cfargument name="data" required="true">
		<cfparam name="variables.savedata" default="#structnew()#">
		<cfset variables.saveddata[name] = data>
	</cffunction>
	
	<cffunction name="isDataSaved">
		<cfargument name="name" required="true">
		<cfparam name="variables.saveddata" default="#structnew()#">
		<cfreturn structkeyexists(variables.saveddata, name)>
	</cffunction>
	
	<cffunction name="getSavedData">
		<cfargument name="name" required="true">
		<cfreturn variables.saveddata[name]>
	</cffunction>
	
	<cffunction name="clearSavedData">
		<cfargument name="name" required="true">
		<cfset structdelete(variables.saveddata,name)>
	</cffunction>
	
	<cffunction name="exportUserData">
		<cfset var s = structnew()>
		<cfset structappend(s, variables.info)>
		<cfif structkeyexists(variables, "saveddata")>
			<cfset structappend(s, variables.saveddata)>
		</cfif>
		<cfreturn s>
	</cffunction>
	
	<cffunction name="dumpsaveddata">
		<cfparam name="variables.saveddata" default="#structnew()#">
		<cfdump var=#variables.saveddata#>
		<cfabort>
	</cffunction>
	
	<cffunction name="getValues">
		<cfreturn duplicate(variables.info)>
	</cffunction>
</cfcomponent>