<cfcomponent name="Permission Level" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		
		<cfset setTableMetaData('{	
			"tableName":"permissionLevels",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Name"},
				"description":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Description"},
				"changedby":{"type":"varchar","maxlen":35},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"},
				"siteid":{"type":"varchar","maxlen":35}
			},
			"hasMany":{
				"permissionLevel.permissionLevelItems":{"allowDeleteWithChildren":1}
			},
			"habtm":{"users.users":{"via":"permissionLevel.permissionLevelsToUsers"}}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="savePL">
		<cfset var id = "">
		<cfset var vdtr = validateSave()>
		
		<cfif NOT vdtr.passValidation()>
			<cfreturn false>
		</cfif>
		
		<cfif variables.itemData.id EQ "">
			<cfset variables.itemdata.id = insertGroup()>
			<cfset variables.observeEvent('insert permissionLevel', variables.itemData)>
		<cfelse>
			<cfset updateGroup()>
			<cfset variables.observeEvent('update permissionLevel', variables.itemData)>
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="insertGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname = "">
		<cfset var itminsrt = "">
		<cfset var id = "">
		<cfset var si = getXmlSecurityItems()>
		<cfset var formdata = variables.itemdata>
		<cfset var sgitm = "">
		<cfset var pliObj = createObject("component","permissionLevel.models.permissionLevelItems").init(requestObj, userObj)>
		<cfset variables.itemdata.id = id>
			
		<cfset this.save()>
		
		<cfset id = this.getId()>
	
		<!--- add records for each security item --->
		<cfloop from="1" to="#arraylen(si)#" index="sgitm">
			<cfset lcl.mysecuritylist = listappend(si[sgitm].securityitems, "View")>
			<cfloop list="#lcl.mysecuritylist#" index="itm">
				<cfset fixedname = rereplace(itm,"[^a-zA-Z0-9]","_","all")>

				<cfif structkeyexists(variables.itemdata, "#si[sgitm].name#_items") 
				  AND listfind(variables.itemdata["#si[sgitm].name#_items"],fixedname)>
					<cfset pliObj.clear()>
					<cfset pliObj.setPermissionLevelId(id)>
					<cfset pliObj.setModuleName(si[sgitm].name)>
					<cfset pliObj.setItemName(itm)>
					<cfset pliObj.save()>
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var sgitem = "">
		<cfset var si = getXmlSecurityItems()>
		<cfset var formdata = variables.itemdata>
		<cfset var pliObj = createObject("component","permissionLevel.models.permissionLevelItems").init(requestObj, userObj)>
	
		<cfset this.save()>

		<!--- clear security items for this item --->
		<cfset clearsecurityItems(variables.itemdata.id)>
				
		<!--- add records for each security item --->
		<cfloop from="1" to="#arraylen(si)#" index="sgitm">
			<cfset lcl.mysecuritylist = listappend(si[sgitm].securityitems, "View")>
			<cfloop list="#lcl.mysecuritylist#" index="itm">
				<cfset fixedname = rereplace(itm,"[^a-zA-Z0-9]","_","all")>
				
				<cfif structkeyexists(variables.itemdata, "#si[sgitm].name#_items") 
				  AND listfind(variables.itemdata["#si[sgitm].name#_items"],fixedname)>
					<cfset pliObj.clear()>
					<cfset pliObj.setPermissionLevelId(variables.itemdata.id)>
					<cfset pliObj.setModuleName(si[sgitm].name)>
					<cfset pliObj.setItemName(itm)>
					<cfset pliObj.save()>
				</cfif>
			</cfloop>
		</cfloop>
					
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="setSecurityItemsFromXml">
		<cfargument name="d" required="true">
		<cfset variables.securityItems = arguments.d>
	</cffunction>
	
	<cffunction name="getXmlSecurityItems">
		<cfreturn securityItems>
	</cffunction>
	

	<cffunction name="clearSecurityItems" output="false">
		<cfargument name="id" required="true">
		
		<cfset var q = "">
		
		<cfquery name="itmclr" datasource="#variables.requestObj.getvar('dsn')#">
			DELETE FROM permissionLevelItems 
			WHERE permissionLevelid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
	</cffunction>

	
	<cffunction name="getUserRights">
		<cfargument name="userid" required="true">
		
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT pli.modulename, pli.itemname
			FROM permissionLevelsToUsers pltu
			INNER JOIN PermissionLevels pl ON (pl.id = pltu.permissionLevelId AND pl.deleted = 0)
			INNER JOIN permissionLevelItems pli ON (pl.id = pli.permissionLevelid AND pli.siteid = pltu.siteid)
			INNER JOIN users u ON (pltu.userid = u.id AND u.deleted = 0 AND u.active = 1)
			WHERE 
				pltu.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar"> 
				AND pltu.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND pltu.deleted = 0
			ORDER BY modulename, itemname
		</cfquery>
		
		<cfreturn g>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT sg.id, sg.name, sg.description, sg.modified
			FROM permissionLevels sg
			WHERE 
			(sg.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
            OR sg.description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
			AND sg.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
           	AND sg.deleted = 0
            UNION 
            
            SELECT sg1.id, sg1.name, sg1.description, sg1.modified
			FROM permissionLevels sg1
            INNER JOIN permissionLevelItems sgi ON sg1.id = sgi.permissionLevelid
			WHERE 
			sgi.itemname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
			AND sg1.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
            AND sg1.deleted = 0
            UNION
            
            SELECT sg2.id, sg2.name, sg2.description, sg2.modified
			FROM permissionLevels sg2
            INNER JOIN permissionlevelsToUsers sgu ON sg2.id = sgu.permissionLevelid AND sgu.deleted = 0
            INNER JOIN users u ON u.id = sgu.userid
			WHERE 
			(u.fname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
             OR u.lname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
			AND sg2.deleted = 0
			AND sg2.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn g>

	</cffunction>
</cfcomponent>
	