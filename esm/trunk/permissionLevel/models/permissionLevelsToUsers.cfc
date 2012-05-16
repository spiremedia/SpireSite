<cfcomponent name="Permission Level To Users" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		
		<cfset setTableMetaData('{	
			"tableName":"permissionLevelsToUsers",
			"fields":{
				"permissionLevelId":{"type":"varchar","maxlen":35,"label":"Level Id"},
				"siteid":{"type":"varchar","maxlen":35},
				"userid":{"type":"varchar","maxlen":35},
				"changedby":{"type":"varchar","maxlen":35},
				"modified":{"type":"date"},
				"deleted":{"type":"bit","default":"false"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>

</cfcomponent>
	