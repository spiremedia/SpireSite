<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"title":{"label":"Form Title","validation":"notblank"},
				"formid":{"label":"Form Identifier","validation":"notblank"}
			}
		}')>
		<cfreturn this>
	</cffunction>
</cfcomponent>	