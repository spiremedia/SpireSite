<cfcomponent name="indexables Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('
			{"FIELDS":{
				"reindex":{"LABEL":"Reindex","TYPE":"bit"},
				"objid":{"VALIDATION":"maxlength,notblank","LABEL":"Objid","MAXLEN":50,"TYPE":"varchar"},
				"description":{"VALIDATION":"maxlength,notblank","LABEL":"Description","MAXLEN":500,"TYPE":"varchar"},
				"tagsJson":{"VALIDATION":"maxlength,notblank","LABEL":"Tags Json","MAXLEN":-1,"TYPE":"varchar"},
				"path":{"VALIDATION":"maxlength,notblank","LABEL":"Path","MAXLEN":200,"TYPE":"varchar"},
				"created":{"LABEL":"Created","TYPE":"date"},
				"moreInfoJson":{"VALIDATION":"maxlength,notblank","LABEL":"More Info Json","MAXLEN":-1,"TYPE":"varchar"},
				"textIndexed":{"VALIDATION":"maxlength,notblank","LABEL":"Text Indexed","MAXLEN":4000,"TYPE":"varchar"},
				"changed":{"LABEL":"Changed","TYPE":"date"},
				"updateXml":{"VALIDATION":"maxlength,notblank","LABEL":"Update Xml","MAXLEN":4000,"TYPE":"varchar"},
				"viewcfc":{"VALIDATION":"maxlength,notblank","LABEL":"Viewcfc","MAXLEN":50,"TYPE":"varchar"},
				"siteId":{"VALIDATION":"maxlength,notblank","LABEL":"Site Id","MAXLEN":35,"TYPE":"varchar"},
				"error":{"VALIDATION":"maxlength,notblank","LABEL":"Error","MAXLEN":4000,"TYPE":"varchar"},
				"lastIndexed":{"LABEL":"Last Indexed","TYPE":"date"},
				"deleted":{"LABEL":"Deleted","DEFAULT":0,"TYPE":"bit"},
				"type":{"VALIDATION":"maxlength,notblank","LABEL":"Type","MAXLEN":50,"TYPE":"varchar"},
				"title":{"VALIDATION":"maxlength,notblank","LABEL":"Title","MAXLEN":100,"TYPE":"varchar"}
			},
			"TABLENAME":"indexables"
			}
		')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
