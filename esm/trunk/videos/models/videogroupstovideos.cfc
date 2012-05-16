<cfcomponent name="videostovideogroups Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"TABLENAME":"videostovideogroups",
			"FIELDS":{
				"created":{"TYPE":"date","LABEL":"Created"},
				"videoid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Videoid","VALIDATION":"maxlength,notblank"},
				"videogroupid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Videogroupid","VALIDATION":"maxlength,notblank"},
				"modified":{"TYPE":"date","LABEL":"Modified"},
				"sortkey":{"TYPE":"integer"}
			}
		}')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
