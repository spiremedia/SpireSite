<cfcomponent name="activityLogs Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"TABLENAME":"activityLogs",
			"FIELDS":{
				"modulename":{"MAXLEN":50,"TYPE":"varchar","LABEL":"Modulename","VALIDATION":"maxlength,notblank"},
				"changedby":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Modifiedby","VALIDATION":"maxlength,notblank"},
				"itemid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Itemid","VALIDATION":"maxlength,notblank"},
				"description":{"TYPE":"varchar","LABEL":"Description","VALIDATION":"notblank"},
				"tablename":{"MAXLEN":50,"TYPE":"varchar","LABEL":"Tablename","VALIDATION":"maxlength,notblank"},
				"created":{"TYPE":"date","LABEL":"Actiondate"},
				"type":{"MAXLEN":50,"TYPE":"varchar"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid"}
			}
		}')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
