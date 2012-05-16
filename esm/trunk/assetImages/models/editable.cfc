<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"assetid":{"label":"Image Asset","validation":"notblank"},
				"link":{"label":"Click Link"}		       
			}
		}')>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>