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
	
	<cffunction name="afterInsertSqlStr">
		<cfreturn "SELECT newid = scope_identity()">
	</cffunction>
	
	<cffunction name="afterSelectSqlStr">
		<cfargument name="conds" required="true">
		
		<cfset var s = " * FROM (SELECT ">
		
		<cfif NOT structkeyexists(conds, "rowscount")>
			<cfreturn "">
		</cfif>

		<cfif NOT structkeyexists(conds, "sort") AND NOT this.hasField("name")>
			<cfthrow message="sql server requires data to have a sort key to use rowcount">
		</cfif>
		
		<cfset s = s & "ROW_NUMBER() OVER (ORDER BY ">
		
		<cfif structkeyexists(conds, "sort")>
			<cfset s = s & conds.sort>
		<cfelse>
			<cfset s = s & this.getTableName() & ".name">
		</cfif>			
		
		<cfset s = s & " ) AS sortrecordnumber, ">
				
		<cfreturn s>
	</cffunction>
	
	<cffunction name="afterWhereConditionsSqlStr">
		<cfargument name="conds" required="true">
		
		<cfset var s = "">
		<cfset var f = structnew()>
		
		<cfif NOT structkeyexists(conds,"rowscount")>
			<cfreturn "">
		</cfif>
			
		<cfif structkeyexists(conds,"rowsstart")>
			<cfset f.rowsstart = conds.rowsstart>
		<cfelse>
			<cfset f.rowsstart = 0>
		</cfif>
	
		<cfif NOT structkeyexists(conds, "rowscount")>
			<cfthrow message="if rowsstart is specficied, rowscount must be as well">
		</cfif>
		
		<cfset f.rowscount = conds.rowscount>		
		<cfset s = s & ") as rs">
		<cfset s = s & " WHERE rs.sortrecordnumber BETWEEN ">
		<cfset s = s & iif(structkeyexists(f,"rowsstart"), DE(f.rowsstart), DE(0))>
		<cfset s = s & " AND ">
		<cfset s = s & (f.rowsstart + f.rowscount)>
		
		<cfreturn s>
	</cffunction>
	
	<cffunction name="orderBySqlStr">
		<!---
			Tricky bit.  The sort is outside the () that make the subquery which is namespaced rs.  
			Replace tablenames with rs to get it to not have name space issue 
		--->
		
		<cfargument name="conds" required="true">
		
		<cfset var s = super.orderBySqlStr(conds)>
		<cfif NOT structkeyexists(conds,"rowscount")>
			<cfreturn s>
		</cfif>
		
		<cfreturn rereplace(s, "[^ \.]+\.", "rs.", "all")>
	</cffunction>
	
</cfcomponent>