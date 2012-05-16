<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"assetids":{"label":"Form Identifyer"},
				"assetgroupid":{"label":"Form Identifyer"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="validatesave">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = getValidator()>
		<cfset var mylocal = structnew()>
		
		<cfif variables.widgetData.assetgroupid NEQ "" AND variables.widgetData.assetids NEQ "">
			<cfset vdtr.addError('assetGroupName', 'Please choose only one - an Asset Group, or an individual asset.')>
		</cfif>
		
		<cfif variables.widgetData.assetgroupid EQ "" AND variables.widgetData.assetids EQ "">
			<cfset vdtr.addError('assetGroupName', 'Please choose one - an Asset Group, or an individual asset.')>
		</cfif>
		
		<cfreturn vdtr/>
	</cffunction>

</cfcomponent>
	