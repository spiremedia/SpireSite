<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"content":{"label":"Content","validation":"notblank","parseforwysiwyg":"1"}
			}
		}')>
		<cfreturn this>
	</cffunction>
</cfcomponent>