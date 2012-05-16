<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"feedurl":{"label":"Feed Url","validation":"islink"},
				"showtitle":{"label":"Show Title?"},
				"descriptionoptions":{"default":"all","label":"Description Options"},
				"rowcount":{"default":"all","label":"Row count"},
				"rowmaxlen":{"default":200,"label":"Row max length"}
			}
		}')>
				
		<cfreturn this>
	</cffunction>
	
</cfcomponent>