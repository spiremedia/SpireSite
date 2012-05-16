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
			FROM news_log
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
			FROM news_log
			INNER JOIN users ON userid = users.id
			WHERE newsid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="save newsItems">
				<cfset saveMethod(modelref)>
			</cfcase>
			
			<cfcase value="delete newsItems,destroy newsitems">
				<cfset deleteMethod(modelref)>
			</cfcase>
			
			<cfcase value="upload">
				<cfset uploadMethod(modelref)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="saveMethod">
		<cfargument name="mref" required="true">
		<cfset var desc = "">
		<cfif mref.getSaveMode() EQ "insert">
			<cfset desc = 'Added "#arguments.mref.getName()#".'>
		<cfelse>
			<cfset desc = 'Updated "#arguments.mref.getName()#".'>
		</cfif>
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							newsid = arguments.mRef.getid(),
							description = desc)>
	</cffunction>
	
	<cffunction name="deleteMethod">
		<cfargument name="Mref" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							newsid = arguments.mRef.getid(),
							description = 'Deleted "#arguments.mref.getname()#".')>
	</cffunction>
	
	<cffunction name="uploadMethod">
		<cfargument name="mref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							newsid = arguments.mRef.getid(),
							description = 'Uploaded file "#arguments.mref.getFilename()#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="assetid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO news_log (
			id,
			newsid,
			userid,
			description,
			actiondate
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.newsid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		)
		</cfquery>
	</cffunction>
	
</cfcomponent>