<cfcomponent name="tablestruct">
	<cffunction name="get">
		<cfargument name="orm" required="true">
		<cfargument name="tablename" required="true">
	
		<cfset var s = structnew()>
		<cfset var tableinfo = orm.getTableFields(tablename)>
		<cfset var tmp = structnew()>
		
		<cfif tableinfo.recordcount eq 0>
			<cfthrow message = "No fields in table #tablename#">
		</cfif>
		
		<cfset s.fields = structnew()>
		<cfset s.tableName = tablename>

		<cfloop query="tableInfo">
			<cfset tmp = structnew()>
			<cfif NOT listfindnocase("id", tableinfo.name)>
				<cfswitch expression="#type#">
					<cfcase value="varchar,nvarchar">
						<cfset tmp.type = "varchar">
						<cfif  tableinfo.length NEQ -1>
							<cfset tmp.validation = "maxlength">
						</cfif>
						<cfset tmp.maxlen = tableinfo.length>
					</cfcase>
					<cfcase value="text,ntext">
						<cfset tmp.type= "longvarchar">
						<cfset tmp.validation = "notblank">
					</cfcase>
					<cfcase value="real">
						<cfset tmp.type= "real">
						
					</cfcase>
					<cfcase value="int">
						<cfset tmp.type = "integer">
						<cfif name EQ "deleted">
							<cfset tmp.default = 0>
						</cfif>
						<cfif name EQ "active">
							<cfset tmp.default = 1>
						</cfif>
					</cfcase>
					<cfcase value="decimal">
						<cfset tmp.type = "real">
					</cfcase>
					<cfcase value="bit">
						<cfset tmp.type = "bit">
						<cfif name EQ "deleted">
							<cfset tmp.default = 0>
						</cfif>
						<cfif name EQ "active">
							<cfset tmp.default = 1>
						</cfif>
					</cfcase>
					<cfcase value="date">
						<cfset tmp.type = "date">
					</cfcase>
					<cfcase value="datetime,timestamp">
						<cfset tmp.type = "timestamp">
					</cfcase>
				</cfswitch>
	
				<cfset tmp.label = tosingularlabel(tableinfo.name)>
				<cfset s.fields[tableinfo.name] = tmp>
			</cfif>
		</cfloop>

		<cfreturn s/>
	</cffunction>
	
	<cffunction name="toSingularLabel">
		<cfargument name="str">
		<cfset str = rereplace(str, "([A-Z])", " \1","all")>
		<cfset str = rereplace(str, "s$", "")>
		<cfset str = ucase(left(str,1)) & mid(str, 2, len(str))>
		<cfreturn str>
	</cffunction>
	
	<cffunction name="toSingular">
		<cfargument name="str">
		<cfset str = rereplace(str, "s$", "")>
		<cfset str = ucase(left(str,1)) & mid(str, 2, len(str))>
		<cfreturn str>
	</cffunction>
</cfcomponent>

