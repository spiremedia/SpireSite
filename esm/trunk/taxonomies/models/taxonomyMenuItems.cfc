<cfcomponent name="taxonomyMenuItems Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"FIELDS":{
				"modified":{"LABEL":"Modified","TYPE":"date"},
				"taxonomyMenuId":{"VALIDATION":"maxlength,notblank","LABEL":"Taxonomy Menu Id","MAXLEN":35,"TYPE":"varchar"},
				"sortorder":{"LABEL":"Sortorder","TYPE":"integer"},
				"taxonomyId":{"VALIDATION":"maxlength,notblank","LABEL":"Taxonomy Id","MAXLEN":35,"TYPE":"varchar"},
				"created":{"LABEL":"Created","TYPE":"date"},
				"changedby":{"VALIDATION":"maxlength,notblank","LABEL":"Changedby","MAXLEN":35,"TYPE":"varchar"}
			},
			"TABLENAME":"taxonomyMenuItems",
			"hasMany":{"taxonomies.taxonomyMenuFavorites":{}}
		}')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
