<cfcomponent name="defaultsql">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="settabledata">
		<cfargument name="tabledata">
		
		<cfset var pk = structnew()>
		<cfset pk.name = "id">
		<cfset pk.useuuid = true>
		
		<cfset variables.tabledata = arguments.tabledata>
		
		<cfparam name="variables.tabledata.pk" default="#pk#">
	</cffunction>
	
	<cffunction name="singularize">
		<cfargument name="name">
		<cfreturn rereplacenocase(name,"s$", "")>
	</cffunction>
	
	<cffunction name="pluralize">
		<cfargument name="name">
		<cfreturn name & "s">
	</cffunction>
	
	<cffunction name="getTableData">
		<cfreturn variables.tabledata>
	</cffunction>
	
	<cffunction name="getLinkTableName">
		<cfargument name="name1" required="true">
		<cfargument name="name2" required="true">
		<cfset var t = listsort("#name1#,#name2#","textnocase")>
		<cfreturn replace(t, ",", "To")>
	</cffunction>
	
	<cffunction name="hasfield">
		<!--- 
			This function determines if a table definition has a certain field.
		--->
		<cfargument name="f" required="true">
		<cfreturn structkeyexists(variables.tabledata.fields,f) OR variables.tabledata.pk.name EQ f>
	</cffunction>
	
	<cffunction name="hasRelation">
		<cfargument name="t" required="true">
		<cfreturn NOT structisempty(getRelation(t))>
	</cffunction>
	
	<cffunction name="getRelation">
		<!--- 
			this function determines if a model has any relationship with another table.
			these are denoted by the relationship definitions.
			loop thru them and return true if one is found, false otherwise.
		--->
		<cfargument name="t" required="true">
		<cfset var itm = "">
		<cfset var lidx = "">
		<cfset var ret = structnew()>
		<cfloop list="hasMany,habtm,belongsTo" index="lidx">	
			<cfif structkeyexists(variables.tabledata,lidx)>
				<cfloop collection="#variables.tabledata[lidx]#" item="itm">
					<cfif refindnocase("\.#t#$", itm)>
						<cfset ret.relationship = lidx>
						<cfset ret.withModel = itm>
						<cfreturn ret>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="getTableName">
		<cfreturn variables.tabledata.tablename>
	</cffunction>
	
	<cffunction name="save">
		<cfargument name="itemdata" required="true">
		
		<cfset var id = "">
		
		<cfset variables.itemdata = arguments.itemdata>

		<cfif variables.itemdata.id EQ "" OR structkeyexists(variables.itemdata, "forceinsert")>
			<cfset id = insertItem()>
		<cfelse>
			<cfset id = updateItem()>
		</cfif>
		
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertItem" access="private">
		<cfset var l = structnew()>
		<cfset l.allfields = structkeylist(variables.tabledata.fields)>
		
		<!--- handle created --->
		<cfif structkeyexists(variables.tabledata.fields, "created") AND NOT structkeyexists(variables.itemdata, "created")>
			<cfset variables.itemdata.created = now()>
		</cfif>
		
		<!--- handle modified --->
		<cfif structkeyexists(variables.tabledata.fields, "modified") AND NOT structkeyexists(variables.itemdata, "modified")>
			<cfset variables.itemdata.modified = now()>
		</cfif>
		
		<!--- handle siteid --->
		<cfif structkeyexists(variables.tabledata.fields, "siteid") AND NOT structkeyexists(variables.itemdata, "siteid")>
			<cfset variables.itemdata.siteid = variables.userObject.getCurrentSiteId()>
		</cfif>
		
		<!--- handle changedby --->
		<cfif structkeyexists(variables.tabledata.fields, "changedby") AND NOT structkeyexists(variables.itemdata, "changedby")>
			<cfset variables.itemdata.changedby = variables.userObject.getUserId()>
		</cfif>
		
		<!--- handle defaults --->
		<cfloop collection="#variables.tabledata.fields#" item="l.idx">
			<cfif NOT structkeyexists(variables.itemdata, l.idx) 
					AND structkeyexists(variables.tabledata.fields[l.idx], "default")>
				<cfset variables.itemdata[l.idx] = variables.tabledata.fields[l.idx].default>
			</cfif>
		</cfloop>
		
		<cfset l.presentfields = "">
		<cfloop list="#l.allfields#" index="l.idx">
			<cfif structkeyexists(variables.itemdata, l.idx)>
				<cfset l.presentfields = listappend(l.presentfields, l.idx)>
			</cfif>
		</cfloop>
		
		<cfloop list="#l.allfields#" index="l.idx">
			<cfif structkeyexists(variables.tabledata.fields[l.idx],"autoincrement") AND variables.tabledata.fields[l.idx].autoincrement>		
				<cfset l.presentfields = listdeleteat(l.presentfields,listfindnocase(l.presentfields,l.idx))>
			</cfif>
		</cfloop>
			
		<cfif structkeyexists(variables.itemdata, "forceinsert") AND structkeyexists(variables.itemdata, "id")>
			<cfset l.id = variables.itemdata.id>
		<cfelseif NOT (structkeyexists(variables.tabledata.fields,"id") 
						AND structkeyexists(variables.tabledata.fields["id"],"autoincrement") 
							AND variables.tabledata.fields["id"].autoincrement)>		
			<cfset l.id = createuuid()>
		</cfif>

		<cfquery name="l.q" datasource="#requestObject.getVar("dsn")#" result="M">
			INSERT INTO #variables.tabledata.tablename# (
				<cfif isdefined("l.id")>id,</cfif>
				#l.presentfields#
			) VALUES (
				<cfif isdefined("l.id")><cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar">,</cfif>
				<cfloop list="#l.presentfields#" index="l.idx">
					<cfset l.tmptype = variables.tabledata.fields[l.idx].type>
					<cfset l.tmpNull = false>
					<cfif structkeyexists(variables.tabledata.fields[l.idx], "nullIfBlank") AND variables.tabledata.fields[l.idx].nullIfBlank AND variables.itemdata[l.idx] EQ ''>
						<cfset l.tmpNull = true>
					</cfif>
					<cfif listfind("created,modified", l.idx) OR (l.tmptype EQ "date" AND right(l.idx,2) EQ "dt")>
						<cfset l.tmptype = "timestamp">
					</cfif>
					<cfif l.idx NEQ listfirst(l.presentfields)>,</cfif>
					<cfqueryparam value="#variables.itemdata[l.idx]#" cfsqltype="cf_sql_#l.tmptype#" null="#l.tmpNull#">
				</cfloop>
			)
			#afterInsertSqlStr()#
		</cfquery>
		
		<cfif isdefined(l.q.newid)>
			<cfset l.id = l.q.newid>
		</cfif>
		
		<cfif isdefined("request.dumpquery")>
			<cfdump var=#m#><cfabort>
		</cfif>
		
		<cfreturn l.id>		
	</cffunction>
	
	<cffunction name="updateItem" access="private">
		<cfset var l = structnew()>
		
		<cfif NOT structkeyexists(variables.itemdata, "id")>
			<cfthrow message="id not set">
		</cfif>
		
		<cfset l.allfields = structkeylist(variables.tabledata.fields)>
		
		<cfif structkeyexists(variables.tabledata.fields, "modified") AND  NOT structkeyexists(variables.itemdata, "modified")>
			<cfset variables.itemdata.modified = now()>
		</cfif>
		
		<cfif structkeyexists(variables.tabledata.fields, "changedby") AND NOT structkeyexists(variables.itemdata, "changedby")>
			<cfset variables.itemdata.changedby = variables.userObject.getUserId()>
		</cfif>
		
		<cfset l.presentfields = "">
		<cfloop list="#l.allfields#" index="l.idx">
			<cfif structkeyexists(variables.itemdata, l.idx)>
				<cfset l.presentfields = listappend(l.presentfields, l.idx)>
			</cfif>
		</cfloop>

		<!--- remove fields if autoincrement since can't update --->
		<cfloop list="#l.allfields#" index="l.idx">
			<cfif  structkeyexists(variables.tabledata.fields[l.idx],"autoincrement") AND variables.tabledata.fields[l.idx].autoincrement>	
				<cfset l.presentfields = listdeleteat(l.presentfields,listfindnocase(l.presentfields,l.idx))>
			</cfif>
		</cfloop>		

		<cfquery name="l.q" datasource="#requestObject.getVar("dsn")#" result="m">
			UPDATE #variables.tabledata.tablename# SET
			<cfloop list="#l.presentfields#" index="l.idx">
				<cfif l.idx NEQ listfirst(l.presentfields)>,</cfif>
				<cfset l.tmptype = variables.tabledata.fields[l.idx].type>
				<cfset l.tmpNull = false>
				<cfif structkeyexists(variables.tabledata.fields[l.idx], "nullIfBlank") AND variables.tabledata.fields[l.idx].nullIfBlank AND variables.itemdata[l.idx] EQ ''>
					<cfset l.tmpNull = true>
				</cfif>
				<cfif listfind("created,modified", l.idx) OR (l.tmptype EQ "date" AND right(l.idx,2) EQ "dt")>
					<cfset l.tmptype = "timestamp">
				</cfif>
				#l.idx# = <cfqueryparam value="#variables.itemdata[l.idx]#" cfsqltype="cf_sql_#l.tmptype#" null="#l.tmpNull#">
			</cfloop>
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
            <cfif structkeyexists(variables.itemdata, "where")>
            	<cfloop collection="#variables.itemdata.where#" item="l.whereitem"><!--- loop thru the where collection --->
					<cfif structkeyexists(variables.tabledata.fields,l.whereitem)><!--- this line confirms were actually using against existing items --->
						AND #l.whereitem# = <cfqueryparam value="#variables.itemdata.where[l.whereitem]#" cfsqltype="cf_sql_varchar">
					</cfif>
                </cfloop>
            </cfif>
		</cfquery>
		
		<cfif isdefined("request.dumpquery")>
			<cfdump var=#m#><cfabort>
		</cfif>
		
		<!--- <cfcatch>
			<cfoutput>
			UPDATE #variables.tabledata.tablename# SET<br>
			<cfloop list="#l.presentfields#" index="l.idx">
				<cfif l.idx NEQ listfirst(l.presentfields)>,</cfif>
				<cfset l.tmptype = variables.tabledata.fields[l.idx].type>
				<cfif listfind("created,modified", l.idx) OR (l.tmptype EQ "date" AND right(l.idx,2) EQ "dt")>
					<cfset l.tmptype = "timestamp">
				</cfif>
				#l.idx# = &lt;cfqueryparam value="#variables.itemdata[l.idx]#" cfsqltype="cf_sql_#variables.tabledata.fields[l.idx].type#"><br/>
			</cfloop>
			WHERE id = &lt;cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		
			</cfoutput>
			<cfdump var=#cfcatch#>
			<cfabort>
		</cfcatch>
		</cftry> --->
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="id" required="true">
	
		<cfset var lcl = structnew()>

		<cfif isdefined("arguments.id")>
			<cfset variables.itemdata.id = arguments.id>
		</cfif>
					
		<cfquery name="lcl.query" datasource="#requestObject.getVar("dsn")#">
			UPDATE  #variables.tabledata.tablename#
			SET deleted = 1
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			<cfif structkeyexists(variables.tabledata.fields, "siteid")>
				AND siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getVdtr">
		<cfreturn variables.vdtr>
	</cffunction>
	
	<cffunction name="destroy">
		<cfargument name="id" required="true">
				
		<cfset var lcl = structnew()>

		<cfif isdefined("arguments.id")>
			<cfset variables.itemdata.id = arguments.id>
		</cfif>

		<cfquery name="lcl.query" datasource="#requestObject.getVar("dsn")#">
			DELETE FROM #variables.tabledata.tablename#
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			<cfif structkeyexists(variables.tabledata.fields, "siteid")>
				AND siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="destroyBy">
		<cfargument name="field" required="true">
		<cfargument name="value" required="true">
		
		<cfset var lcl = structnew()>

		<cfquery name="lcl.query" datasource="#requestObject.getVar("dsn")#">
			DELETE FROM #variables.tabledata.tablename#
			WHERE #field# = <cfqueryparam value="#value#" cfsqltype="cf_sql_varchar">
			<cfif structkeyexists(variables.tabledata.fields, "siteid")>
				AND siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getBy">
		<cfargument name="field" required="true">
		<cfargument name="value" required="true">
		<cfargument name="more" default="#structnew()#">
		<!--- <cfargument name="moreconditions"> --->
		
		<cfset var lcl = structnew()>
		
		<cfset more[arguments.field] = arguments.value>

		<cfreturn getAll(more)>
	</cffunction>
	
	<cffunction name="getAll"><!--- and count --->
		<cfargument name="conditions" default="#structnew()#">
		
		<cfset var lcl = structnew()>

		<!--- info contains sort, count, and where info which must be seperated --->
		<cfset lcl.where = structnew()>

		<!--- loop over conditions and add only fields in collection --->
		<cfloop collection="#conditions#" item="lcl.conditionitem">
			<cfif hasfield(lcl.conditionitem)>
				<cfset lcl.where[lcl.conditionitem] = arguments.conditions[lcl.conditionitem]>
			</cfif>
		</cfloop>
		
		<!--- prepopulate deleted if not set --->
		<cfif hasfield("deleted") AND not structkeyexists(lcl.where, "deleted")>
			<cfset lcl.where.deleted = 0>
		</cfif>
		
		<!--- prepopulate siteid if it exists in tbl --->
		<cfif structkeyexists(variables.tabledata.fields, "siteid") AND NOT structkeyexists(conditions,"nositeid" )>
			<cfset lcl.where.siteid = variables.userObject.getCurrentSiteId()>
		</cfif>
		
		<cfset lcl.fieldlist = structkeylist(variables.tabledata.fields)>
		<cfset lcl.fieldlist = "#variables.tabledata.tablename#." & replace(lcl.fieldlist,",",", #variables.tabledata.tablename#.","all")>
		
		<cfset lcl.belongstodup = structnew()>

		<!--- manage some items for effieicney (remove joins if undesired) --->
		<cfif NOT structkeyexists(arguments.conditions, "ignorebelongsto") AND structkeyexists(variables.tableData, "belongsTo")>
			<cfset lcl.belongstodup = duplicate(variables.tableData.belongsTo)>
		</cfif>

		<!--- add if table has changedby inner join on users with join info --->
		<cfif hasfield("changedby") AND NOT structkeyexists(lcl.belongstodup, "users.users")>
			<cfset lcl.belongstodup["users.users"] = structnew()>
			<cfset lcl.belongstodup["users.users"].joinfields = " users.lname + ', ' + users.fname as fullname">
			<cfset lcl.belongstodup["users.users"].foreignkey = "changedby">
		</cfif>

		<cfquery name="lcl.query" datasource="#requestObject.getVar("dsn")#" result="m">
			SELECT 
			<cfif structkeyexists(conditions, "count")> 
				count(*) cnt
			<cfelse>
				#afterSelectSqlStr(conditions)#
				#variables.tabledata.tablename#.id, #lcl.fieldlist# #getAliasesSql()#
				<cfif structkeyexists(lcl, "belongsTodup")>
					<cfloop collection="#lcl.belongsToDup#" item="lcl.belongstokey">
						<cfif structkeyexists(lcl.belongsToDup[lcl.belongstokey],"joinfields")>
							<cfset lcl.tmp = lcl.belongsToDup[lcl.belongstokey].joinfields>
							, #preservesinglequotes(lcl.tmp)#
						<cfelse>
							, #listlast(lcl.belongstokey, ".")#.id as #listlast(lcl.belongstokey, ".")#_id, #listlast(lcl.belongstokey, ".")#.name as #listlast(lcl.belongstokey, ".")#_name
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			
			FROM #showTableNameStr(conditions, lcl.fieldlist)#
			
			<cfif structkeyexists(lcl, "belongsTodup")>
				<cfloop collection="#lcl.belongsToDup#" item="lcl.belongstokey">
					INNER JOIN 
					#listlast(lcl.belongstokey, ".")#
					ON
						#listlast(lcl.belongstokey, ".")#.id 
							= #variables.tabledata.tablename#.<cfif structkeyexists(lcl.belongsToDup[lcl.belongstokey], "foreignkey")>#lcl.belongsToDup[lcl.belongstokey].foreignkey#<cfelse>#rereplace(listlast(lcl.belongstokey, "."),"s$","")#id</cfif>
					<cfif structkeyexists(lcl.belongsToDup[lcl.belongstokey], "morevalues")>
						<cfloop collection="#lcl.belongsToDup[lcl.belongstokey].morevalues#" item="lcl.belongstokeymore">
							AND #lcl.belongstokeymore# = <cfqueryparam value="#lcl.belongsToDup[lcl.belongstokey].morevalues[lcl.belongstokeymore]#">
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>

			<cfif structkeyexists(arguments.conditions, "joins")>
				<cfloop collection="#arguments.conditions.joins#" item="lcl.joinskey">
					INNER JOIN 
					#lcl.joinskey#
					ON (1 = 1 
					<cfif structkeyexists(arguments.conditions.joins[lcl.joinskey], "values")>
						<cfloop collection="#arguments.conditions.joins[lcl.joinskey].values#" item="lcl.joinssubkey">
							AND #lcl.joinssubkey# 
								= <cfqueryparam value="#arguments.conditions.joins[lcl.joinskey].values[lcl.joinssubkey]#">
							
						</cfloop>
					</cfif>
					<cfif structkeyexists(arguments.conditions.joins[lcl.joinskey], "equalities")>
						<cfloop collection="#arguments.conditions.joins[lcl.joinskey].equalities#" item="lcl.joinssubkey">
							AND #lcl.joinssubkey# 
								= #arguments.conditions.joins[lcl.joinskey].equalities[lcl.joinssubkey]#
							
						</cfloop>
					</cfif>)
				</cfloop>
			</cfif>
	
			<cfif NOT structisempty(lcl.where)>
			WHERE 1 = 1
				<cfloop collection="#lcl.where#" item="lcl.widx">
					<cfif lcl.widx EQ "Id">
						AND #variables.tabledata.tablename#.id = <cfqueryparam value="#lcl.where[lcl.widx]#" cfsqltype="cf_sql_varchar">
					<cfelseif structKeyExists(conditions, "like") AND (variables.tabledata.fields[lcl.widx].type neq "bit")>
						AND #variables.tabledata.tablename#.#lcl.widx# LIKE <cfqueryparam value="%#lcl.where[lcl.widx]#%" cfsqltype="cf_sql_#variables.tabledata.fields[lcl.widx].type#">
					<cfelse>
						AND #variables.tabledata.tablename#.#lcl.widx# = <cfqueryparam value="#lcl.where[lcl.widx]#" cfsqltype="cf_sql_#variables.tabledata.fields[lcl.widx].type#">
					</cfif>
				</cfloop>
			</cfif>
			#afterWhereConditionsSqlStr(conditions)#
			#orderBySqlStr(conditions)#
			#beforeEndofSqlStr(conditions)#
		</cfquery>
		
		<cfif isdefined("request.dumpquery")>
			<cfdump var=#m#><cfabort>
		</cfif>
		
		<cfif structkeyexists(conditions, "count")> 
			<cfreturn lcl.query.cnt>
		<cfelse>
			<cfreturn lcl.query>
		</cfif>
		
	</cffunction>

	<!--- To be overwritten by specific implementations --->
	<cffunction name="afterWhereConditionsSqlStr">
		<cfreturn "">
	</cffunction>
	
	<cffunction name="afterInsertSqlStr">
		<cfreturn "">
	</cffunction>
	
	<cffunction name="afterSelectSqlStr">
		<cfreturn "">
	</cffunction>	
	
	<cffunction name="beforeEndofSqlStr">
		<cfreturn "">
	</cffunction>
	
	<cffunction name="orderBySqlStr">
		<cfargument name="conds" required="true">
		<cfif structkeyexists(arguments.conds,"sort")>
			<cfreturn " ORDER BY #arguments.conds.sort#">
		<cfelseif structkeyexists(variables.tabledata,"defaultsort")>
			<cfreturn " ORDER BY #IIF(structkeyexists(variables.tabledata.fields, variables.tabledata.defaultsort), 'variables.tabledata.tablename & "."', DE(""))##variables.tabledata.defaultsort#">
		<cfelseif this.hasfield("name") AND NOT structkeyexists(conds, "count")>
			<cfreturn " ORDER BY #variables.tabledata.tablename#.name">
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="showTableNameStr">
		<!--- <cfargument name="tablename" required="true">
		<cfargument name="conds" required="true"> --->
		<cfreturn variables.tabledata.tablename>
	</cffunction>
	
	<cffunction name="getAliasesSql">
		<cfset var s = "">
		<cfset var alidx = "">
		
		<cfif structkeyexists(variables.tabledata,"aliases")>
			<cfset s = "">
			<cfloop collection="#variables.tabledata.aliases#" item="alidx">
				<cfset s = s & "," & variables.tabledata.aliases[alidx] & " AS " & alidx>
			</cfloop>
		</cfif>
		
		<cfreturn s>
	</cffunction>
</cfcomponent>