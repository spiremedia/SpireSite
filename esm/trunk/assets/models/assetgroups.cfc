 <cfcomponent name="Asset Groups" output="false" extends="resources.abstractmodel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.requestobj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfset setTableMetaData('{	
			"tableName":"assetGroups",
			"fields":{
				"name":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Name"},
				"description":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Description"},
				"changedby":{"type":"varchar","maxlen":35},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"}
			},
			"hasMany":{"assets.assets":{}}
		}')>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAssetGroups">
		<cfset var l = structnew()>
		<cfreturn this.getAll(l)>
	</cffunction>
	
	<!--- <cffunction name="getGroupTypes" output="false">

		<cfset var sg = "">
		
		<cfif variables.userobj.issuper()>
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT id, name
				FROM assetGroups_view
				ORDER BY name
			</cfquery>
		<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT 
					assetgroupid AS id, assetgroupname AS name
				FROM assetGroupsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				ORDER BY name
			</cfquery>
		</cfif>
		
		<cfreturn sg>
	</cffunction> --->
</cfcomponent>