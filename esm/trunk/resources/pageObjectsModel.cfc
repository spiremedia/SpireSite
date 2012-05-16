<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>

		<cfset setTableMetaData('{
			"TABLENAME":"pageObjects",
			"FIELDS":{
				"memberType":{"MAXLEN":50,"TYPE":"varchar","LABEL":"Member Type"},
				"data":{"TYPE":"varchar","LABEL":"Data","VALIDATION":"notblank"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid","VALIDATION":"notblank"},
				"module":{"MAXLEN":30,"TYPE":"varchar","LABEL":"Module","VALIDATION":"maxlength,notblank"},
				"name":{"MAXLEN":30,"TYPE":"varchar","LABEL":"Name","VALIDATION":"maxlength,notblank"},
				"title":{"MAXLEN":100,"TYPE":"varchar","LABEL":"Title","VALIDATION":"maxlength"},
				"status":{"MAXLEN":50,"TYPE":"varchar","LABEL":"Status","VALIDATION":"maxlength,notblank"},
				"pageid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Pageid","VALIDATION":"notblank"}
			}
		}')>
		<!--- "deleted":{"LABEL":"Deleted","TYPE":"bit","DEFAULT":0}, --->
		<cfreturn this>
	</cffunction>
</cfcomponent>