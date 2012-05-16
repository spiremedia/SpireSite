<cfcomponent name="model" output="false" extends="resources.abstractmodel">
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfargument name="userObj">
		<cfset variables.userObj = arguments.userObj>
		<cfset variables.requestObj = arguments.requestObj>

		<cfset setTableMetaData('{	
			"tableName":"stagedBlockPageObjects",
			"fields":{
				"name":{"type":"varchar","maxlen":30,"validation":"notblank,maxlength","label":"Template Spot"},
				"blockname":{"type":"varchar","maxlen":30,"validation":"notblank,maxlength","label":"Block Name"},
				"sortorder":{"type":"integer","validation":"notblank", "label":"Block Rank"},
				"title":{"type":"varchar","maxlen":100,"validation":"maxlength","label":"Title"},
				"module":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Module"},
				"location":{"type":"varchar","maxlen":500,"validation":"notblank,maxlength","label":"Path"},
				"behavior":{"type":"varchar","validation":"notblank","label":"Match Type"},
				"membertype":{"type":"varchar","validation":"notblank","label":"Membertype"},
				"changedby":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Changedby","VALIDATION":"maxlength,notblank"},
				"deleted":{"type":"bit","default":0},
				"active":{"type":"bit","default":1},
				"created":{"type":"datetime"},
				"data":{"type":"varchar"},
				"modified":{"type":"datetime"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid","VALIDATION":"maxlength,notblank"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getBlocks">
		<cfset var q = "">
			
		<cfquery name="q" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT id, 
				blockname,
				name,
				[module],
				location				
			FROM stagedBlockPageObjects
			WHERE 
				siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND deleted = 0
			ORDER BY sortorder
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="publish">
		<cfargument name="publishBlockObj" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset this.load(this.getId())>
		<cfset lcl.valuestosave = this.getValues()>

		<!--- have to reload it to capture the data and title fields not present here --->
		<cfset lcl.exists = publishBlockObj.load(this.getId())>

		<!--- check if a published record exists, if not forceinsert with same id --->
		<cfif NOT lcl.exists>
			<cfset lcl.valuestosave.forceinsert = 1>
		</cfif>
		
		<cfset publishBlockObj.setValues(lcl.valuestosave)>
		
		<cfset publishBlockObj.save()>
	</cffunction>
</cfcomponent>