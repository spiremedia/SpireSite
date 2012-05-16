<cfcomponent name="Permission Level Items" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		
		<cfset setTableMetaData('{	
			"tableName":"permissionLevelItems",
			"fields":{
				"permissionLevelId":{"type":"varchar","maxlen":35,"label":"Level Id"},
				"itemName":{"type":"varchar","maxlen":100,"validation":"maxlength","label":"Item Name"},
				"moduleName":{"type":"varchar","maxlen":50,"validation":"maxlength","label":"Module Name"},
				"siteid":{"type":"varchar","maxlen":35}
			}
		}')>
		<!--- "belongsTo":{"permissionLevel.permissionLevels":{}} --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPermissions">
		<cfargument name="id" required="true">
		<cfset var l = structNEW()>
		
		<cfset l.sort = "modulename, itemname">
		<cfset l.q = this.getBypermissionLevelId(id,l)>
		<cfset l.r = structNEW()>
		
		<cfoutput query="l.q" group="modulename">
			<cfset l.r[modulename] = structnew()>
			<cfset l.r[modulename]['items'] = ''>
			<cfoutput>
				<cfset l.r[modulename]['items'] = 
					listappend(l.r[modulename]['items'],itemname)>
			</cfoutput>
		</cfoutput>
		
		<cfreturn l.r>
	</cffunction>
	
	
	
	<!---
	<cffunction name="getPermissionLevelItems" output="false">
		<cfset this.>
		<cfquery name="sg.Itemquery" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				sgid, name, description, itemname, modulename
			FROM securityGroupItems_join
			WHERE sgid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND sgisiteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		

		
		<!--- reformat into object of objects for better usefulenss --->
		<cfset sg.itemstruct = structnew()>
		
		<cfoutput query="sg.itemquery" group="modulename">
			<cfset sg.itemstruct[modulename] = structnew()>
			<cfset sg.itemstruct[modulename]['items'] = ''>
			<cfoutput>
				<cfset sg.itemstruct[modulename]['items'] = 
					listappend(sg.itemstruct[modulename]['items'],itemname)>
			</cfoutput>
		</cfoutput>
	--->
</cfcomponent>
	