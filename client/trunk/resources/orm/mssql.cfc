<cfcomponent name="mssql" extends="sql">
	
	<cffunction name="getTables">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
			SELECT table_name
			FROM information_schema.tables
			WHERE table_type = 'BASE TABLE'
			ORDER BY table_name
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getTableFields">
		<cfargument name="tableName">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
			SELECT column_name name, data_type type, is_nullable nullable, ordinal_position sort, character_maximum_length length
			FROM information_schema.columns
			WHERE table_name = <cfqueryparam value="#tablename#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	
	
</cfcomponent>