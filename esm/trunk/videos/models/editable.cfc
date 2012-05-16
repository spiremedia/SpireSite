<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
				
		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"groupid":{"label":"Group Id"}		
			}
		}')>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="validatesave">	
			
		<cfset var lcl = structnew()>
		<cfset var vdtr = getValidator()>
		
		<cfset super.validateSave()>
		
		<cfif this.getgroupid() EQ "">
			<cfset vdtr.addError('groupName', 'Please choose one a Group.')>
		</cfif>

		<cfreturn vdtr/>
	</cffunction>

</cfcomponent>