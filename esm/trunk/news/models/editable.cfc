<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"moduleaction":{"label":"Display","validation":"notblank"},
		        "itemid":{},
				"pageing":{"default":10,"label":"Pageing"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>