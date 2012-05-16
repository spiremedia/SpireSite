<cfcomponent name="model" output="false" extends="resources.abstractmodel">
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfargument name="userObj">
		<cfset variables.userObj = arguments.userObj>
		<cfset variables.requestObj = arguments.requestObj>

		<cfset setTableMetaData('{	
			"tableName":"publishedBlockPageObjects",
			"fields":{
				"name":{"type":"varchar","maxlen":30,"validation":"notblank,maxlength","label":"Template Spot"},
				"blockname":{"type":"varchar","maxlen":30,"validation":"notblank,maxlength","label":"Block Name"},
				"sortorder":{"type":"integer","validation":"notblank", "label":"Block Rank"},
				"title":{"type":"varchar","maxlen":100,"validation":"maxlength","label":"Title"},
				"module":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Module"},
				"location":{"type":"varchar","maxlen":500,"validation":"notblank,maxlength","label":"Path"},
				"behavior":{"type":"varchar","validation":"notblank","label":"Match Type"},
				"changedby":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Changedby","VALIDATION":"maxlength,notblank"},
				"active":{"type":"bit","default":1},
				"membertype":{"type":"varchar","validation":"notblank","label":"Membertype"},
				"created":{"type":"datetime"},
				"data":{"type":"varchar"},
				"modified":{"type":"datetime"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid","VALIDATION":"maxlength,notblank"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>