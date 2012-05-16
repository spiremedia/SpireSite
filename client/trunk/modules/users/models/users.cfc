<cfcomponent name="customers" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<!--- <cfset startorm("customers")> --->
		<cfreturn this>
	</cffunction>
	
	<!--- <cffunction name="validatesave">
		<cfset var lcl = structnew()>
		
		<cfset lcl.vdtr = super.validateSave()>
		<cfset lcl.other = this.getByEmail(variables.itemdata.email)>
		
		<cfif lcl.other.recordcount EQ 0>
			<cfreturn lcl.vdtr>
		</cfif>
		
		<cfif structkeyexists(variables.itemdata,"id") AND lcl.other.id EQ variables.itemdata.id>
			<cfreturn lcl.vdtr>
		</cfif>
		
		<cfset lcl.vdtr.addError("email","This email is already in the system for another user. Please choose another.")>
		
		<cfreturn lcl.vdtr>
	</cffunction> --->
	
</cfcomponent>