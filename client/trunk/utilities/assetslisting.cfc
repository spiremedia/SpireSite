<cfcomponent name="assetslisting">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<!--- <cfargument name="userObject" required="true"> --->
		<cfset variables.requestObject = arguments.requestObject>
		<!--- <cfset variables.userObject = arguments.userObject> --->
		<cfreturn this>
	</cffunction>
	<cffunction name="getAssetsListing">
		<cfargument name="name" required="true">
		<cfset var l = "">
		<cfquery name="l" datasource="#requestObject.getVar("dsn")#">
			SELECT a.id, a.name, a.filename, a.filesize 
			FROM assetGroups ag
			INNER JOIN assets a ON a.assetgroupid = ag.id AND a.filename is not null AND a.filename <> '' AND a.deleted = 0
			WHERE 
				ag.deleted = 0 
				AND ag.name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
			ORDER BY a.modified, a.created
		</cfquery>
		
		<cfloop query="l">
			<cfif l.filesize NEQ "">
				<cfset l.filesize[l.currentrow] = numberformat(int(l.filesize[l.currentrow])/1024, "________._")>
			</cfif>
		</cfloop>
		
		<cfreturn l>
	</cffunction>
</cfcomponent>