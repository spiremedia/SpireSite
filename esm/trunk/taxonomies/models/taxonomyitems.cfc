<cfcomponent name="taxonomy_items Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"FIELDS":{
				"modified":{"LABEL":"Modified","TYPE":"date"},
				"name":{"VALIDATION":"maxlength,notblank","LABEL":"Name","MAXLEN":50,"TYPE":"varchar"},
				"safename":{"LABEL":"sAFEName","MAXLEN":50,"TYPE":"varchar"},
				"description":{"VALIDATION":"maxlength,notblank","LABEL":"Description","MAXLEN":4000,"TYPE":"varchar"},
				"taxonomyid":{"VALIDATION":"notblank","MAXLEN":4000,"TYPE":"varchar"},
				"created":{"LABEL":"Created","TYPE":"date"},
				"deleted":{"LABEL":"Deleted","DEFAULT":0,"TYPE":"bit"},
				"sortkey":{"VALIDATION":"isinteger,notblank","LABEL":"Sort Key","DEFAULT":0,"TYPE":"Integer"},
				"changedby":{"VALIDATION":"maxlength,notblank","LABEL":"Changedby","MAXLEN":35,"TYPE":"varchar"}
			},
			"TABLENAME":"taxonomyitems",
			"belongsTo":{"taxonomies.taxonomy":{}}
		}')>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="prepsafename">
		<cfquery name="q" datasource="#requestObj.getVar("dsn")#">
			UPDATE taxonomyitems SET safename = REPLACE(
													REPLACE(
														REPLACE(
															REPLACE(
																REPLACE(
																	REPLACE(
																		REPLACE(LOWER(name),' ','_'),
																	'$',''),
																'-','_'),
															'''',''),
														'/',''),
													'+',''),
												'-','')
		</cfquery>
	</cffunction>
	
</cfcomponent>