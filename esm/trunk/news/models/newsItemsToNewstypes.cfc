<cfcomponent name="News to NewsTypes" output="false" extends="resources.abstractmodel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		
		<cfset setTableMetaData('{	
			"tableName":"newsItemsToNewsTypes",
			"fields":{
				"newstypeid":{"type":"varchar","maxlen":35,"validation":"notblank"},
				"newsitemid":{"type":"varchar","maxlen":35,"validation":"notblank"},
				"siteid":{"type":"varchar","maxlen":35}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>