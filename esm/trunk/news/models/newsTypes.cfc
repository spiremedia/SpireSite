<cfcomponent name="News Groups" output="false" extends="resources.abstractmodel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		
		<cfset setTableMetaData('{	
			"tableName":"newsTypes",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Name"},
				"title":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Title"},
				"description":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Description"},
				"changedby":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Changedby","VALIDATION":"maxlength,notblank"},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid","VALIDATION":"maxlength,notblank"},
				"hasrssfeed":{"TYPE":"bit","LABEL":"Hasrssfeed"}
			},
			"habtm":{"news.newsItems":{}}
		}')>
		<cfreturn this>
	</cffunction>
</cfcomponent>