<cfcomponent name="taxonomy Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{	
			"FIELDS":{
				"name":{"VALIDATION":"maxlength,notblank","LABEL":"Name","MAXLEN":50,"TYPE":"varchar"},
				"description":{"VALIDATION":"maxlength,notblank","LABEL":"Description","MAXLEN":4000,"TYPE":"varchar"},
				"changedby":{"type":"varchar","maxlen":35},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"}
			},
			"TABLENAME":"taxonomy",
			"hasMany":{"taxonomies.taxonomyItems":{}}
		}')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
