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
			FROM newstypes_log
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
			FROM newstypes_log
			INNER JOIN users ON userid = users.id
			WHERE newstypeid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="save newstypes">
				<cfset saveNewstype(modelRef)>
			</cfcase>
		
			<cfcase value="delete newstypes,destroy newstypes">
				<cfset deleteNewsType(modelRef)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="saveNewsType">
		<cfargument name="mref" required="true">
		<cfset var desc = "">
		<cfif mref.getSaveMode() EQ "insert">
			<cfset desc = 'Added News Type "#mref.getName()#".'>
		<cfelse>
			<cfset desc = 'Updated News Type "#mref.getName()#".'>
		</cfif>
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							newstypeid = mref.getid(),
							description = desc)>
	</cffunction>
	
	<cffunction name="deleteNewsType">
		<cfargument name="mref" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							newstypeid = mref.getid(),
							description = 'Deleted News Type "#mref.getName()#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="newstypeid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO newstypes_log (
			id,
			newstypeid,
			userid,
			description
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.newstypeid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>