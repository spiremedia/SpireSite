<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addSecurityIP">
		<cfargument name="ip" required="true">
		<cfargument name="userid" required="true">
		<cfargument name="usertype" required="false" default="User">
		
		<cfquery name="qry" datasource="#variables.requestObj.getvar('dsn')#">
			INSERT INTO securityIPs (ip,userid,usertype)
			VALUES (
				<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.usertype#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>  
		
	</cffunction>

</cfcomponent>
	