<cfcomponent name="myssql" extends="sql">
	
	<cffunction name="getTables">
		<cfthrow message="getTables not done for mysql">
	</cffunction>
	
	<cffunction name="getTableFields">
		<cfargument name="tableName">
		<cfthrow message="getTableFields not done for mysql">
	</cffunction>
	
	<cffunction name="beforeEndofSqlStr">
		<cfargument name="conds" required="true">
		<cfset var s = "">
		<cfset var f = structnew()>
		
		<cfif structkeyexists(conds,"rowsstart")>
			<cfset f.rowsstart = conds.rowsstart>
			<cfif NOT structkeyexists(conds, "rowscount")>
				<cfthrow message="if rowsstart is specficied, rowscount must be as well">
			</cfif>
			<cfset f.rowscount = conds.rowscount>
		</cfif>
				
		<cfif NOT structisempty(f)>
			<cfset s = " LIMIT">
			<cfset s = s & iif(structkeyexists(f,"rowsstart"), DE(f.rowsstart), DE(0))>
			<cfset s = s & ",">
			<cfset s = s & f.rowscount>
		</cfif>
		
		<cfreturn s>
	</cffunction>
	
</cfcomponent>