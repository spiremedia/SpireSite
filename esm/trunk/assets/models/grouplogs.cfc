<cfcomponent name="logobserver">
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getRecentHistory">
		<cfargument name="days" type="numeric" default="10">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM assetgroups_log
			INNER JOIN users ON userid = users.id
			WHERE actiondate > <cfqueryparam value="#(now() - arguments.days)#" cfsqltype="cf_sql_date">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="getItemHistory">
		<cfargument name="id" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM assetgroups_log
			INNER JOIN users ON userid = users.id
			WHERE assetgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="save assetgroups">
				<cfset saveAssetgroup(modelRef)>
			</cfcase>
			
			<cfcase value="delete assetgroups">
				<cfset deleteAssetgroup(modelRef)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="saveAssetgroup">
		<cfargument name="modelRef" required="true">
		<cfset var desc = "">
		
		<cfif modelRef.getSaveMode() EQ "insert">
			<cfset desc = 'Added Asset Group "#modelRef.getName()#".'>
		<cfelse>
			<cfset desc = 'Updated Asset Group "#modelRef.getName()#".'>
		</cfif>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetgroupid = modelRef.getId(),
							description = desc)>
	</cffunction>
	
	<cffunction name="deleteAssetgroup">
		<cfargument name="modelRef" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetgroupid = modelRef.getId(),
							description = 'Deleted Asset Group "#modelRef.getName()#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="assetgroupid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO assetgroups_log (
			id,
			assetgroupid,
			userid,
			description
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.assetgroupid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>