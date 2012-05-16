<cfcomponent name="logobserver" extends="resources.systemlogs">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		
		<cfset setLogInfo('{
			"moduleName":"Users",
			"tableName":"users",
			"nositeid":true,
			"events":{
				"save users":{"message":"{savemode} user &quot;{username}&quot;."},
				"delete users":{"message":"Deleted user &quot;{username}&quot;."},
				"user updates password":{"message":"Deleted user &quot;{username}&quot;."}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getUsersActivities">
		<cfargument name="userid" required="true">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT al1.created, s1.name, al1.id, al1.modulename, al1.description, u1.fname + ' ' + u1.lname fullname
			FROM activityLogs al1
			INNER JOIN users u1 ON al1.changedby = u1.id
			LEFT OUTER JOIN sites s1 ON s1.id = al1.siteid
			WHERE al1.created > getDate() - 10
			AND u1.id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar"> 
			
			UNION 
			
			SELECT al2.created, s2.name, al2.id, al2.modulename, al2.description, u2.fname + ' ' + u2.lname fullname
			FROM activityLogs al2
			INNER JOIN users u2 ON al2.changedby = u2.id
			LEFT OUTER JOIN sites s2 ON s2.id = al2.siteid
			WHERE al2.created > getDate() - 10
			AND al2.itemid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar"> 
			
			ORDER BY 1 DESC
		</cfquery>

		<cfreturn add>
	</cffunction>
	<!---
	<cffunction name="getRecentHistory">
		<cfargument name="userObj" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM users_log
			INNER JOIN users ON userid = users.id
			WHERE actiondate > getDate() - 10
			AND siteid = <cfqueryparam value="#userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	--->
	<!---
	<cffunction name="getItemHistory">
		<cfargument name="id" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM users_log
			INNER JOIN users ON userid = users.id
			WHERE usersid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	--->
	<!---
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="save users">
				<cfset saveUser(moreInfo)>
			</cfcase>
			<cfcase value="delete users">
				<cfset deleteUser(moreInfo)>
			</cfcase>
			<cfcase value="user updates password">
				<cfset userUpdatesPassword(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="saveUser">
		<cfargument name="moreinfo" required="true">
		<cfset var d = "">
		<cfif moreinfo.savemode EQ "insert">
			<cfset d = 'Added user "#moreinfo.username#".'>
		<cfelse>
			<cfset d = 'Updated user "#moreinfo.username#".'>
		</cfif>
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = d)>
	</cffunction>
	
	<cffunction name="updateUser">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'Updated user "#moreinfo.username#".')>
	</cffunction>
	
	<cffunction name="deleteUser">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'Deleted user "#moreinfo.username#".')>
	</cffunction>
	
	<cffunction name="userUpdatesPassword">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'User updates password.')>
	</cffunction>
	
	<cffunction name="updatedContentObject">
		<cfargument name="pageref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = arguments.pageRef.getField('id'),
							description = 'Updated content Object ## on "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="addedContentObject">
		<cfargument name="pageref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = arguments.pageRef.getField('id'),
							description = 'Added Content Object ## on "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="usersid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO users_log (
			id,
			usersid,
			userid,
			description,
			siteid
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.usersid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	--->
</cfcomponent>