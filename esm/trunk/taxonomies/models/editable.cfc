<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"menuid":{"label":"Taxonomy Menu", "validation":"notblank"},
				"moduleaction":{"label":"Action"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>