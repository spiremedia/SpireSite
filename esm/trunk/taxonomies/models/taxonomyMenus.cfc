<cfcomponent name="taxonomyMenus Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"FIELDS":{
				"modified":{"LABEL":"Modified","TYPE":"date"},
				"name":{"VALIDATION":"maxlength,notblank","LABEL":"Name","MAXLEN":50,"TYPE":"varchar"},
				"baseTaxonomyItemId":{"VALIDATION":"maxlength,notblank","LABEL":"Base Relation","MAXLEN":50,"TYPE":"varchar"},
				"created":{"LABEL":"Created","TYPE":"date"},
				"changedby":{"VALIDATION":"maxlength,notblank","LABEL":"Changedby","MAXLEN":35,"TYPE":"varchar"}
			},
			"TABLENAME":"taxonomyMenus",
			"hasMany":{"taxonomies.taxonomyMenuItems":{}}
		}')>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMenuDetails">
		<cfargument name="id" required="true">
		<cfquery name="q" datasource="#requestObj.getVar("dsn")#">
			SELECT tm.id, tm.name, 
					tmiinfo.name itemname, tmi.taxonomyid tmitaxonomyid, tmi.id tmiid,
					tmf.id tmfid, tmf.taxonomyItemId tmftaxonomyitemid
			FROM taxonomyMenus tm
			INNER JOIN taxonomyMenuItems tmi ON tm.id = tmi.taxonomymenuid
			INNER JOIN taxonomy tmiinfo ON tmiinfo.id = tmi.taxonomyid
			LEFT OUTER JOIN taxonomyMenuFavorites tmf ON tmf.taxonomymenuitemid = tmi.id
			WHERE tm.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY tmi.sortorder
		</cfquery>
		<cfreturn q>
	</cffunction>
	
</cfcomponent>
