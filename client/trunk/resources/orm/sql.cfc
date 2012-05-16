<cfcomponent name="defaultsql">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
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
	
	<cffunction name="hasfield">
		<cfargument name="f" required="true">
		<cfreturn structkeyexists(variables.tabledata.fields,f) OR variables.tabledata.pk.name EQ f>
	</cffunction>
	
	<cffunction name="getTableName">
		<cfreturn variables.tabledata.tablename>
	</cffunction>
	
	<cffunction name="save">
		<cfargument name="itemdata" required="true">
		
		<cfset var id = "">
		
		<cfset variables.itemdata = arguments.itemdata>

		<cfif variables.itemdata.id EQ "">
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
			<cfset variables.itemdata.siteid = requestObject.getVar("siteid")>
		</cfif>

		<!--- handle defaults --->
		<cfloop collection="#variables.tabledata.fields#" item="l.idx">
			<cfif NOT structkeyexists(variables.itemdata, l.idx) AND structkeyexists(variables.tabledata.fields[l.idx], "default")>
				<cfset variables.itemdata[l.idx] = variables.tabledata.fields[l.idx].default>
			</cfif>
		</cfloop>
		
		<cfset l.presentfields = "">
		<cfloop list="#l.allfields#" index="l.idx">
			<cfif structkeyexists(variables.itemdata, l.idx)>
				<cfset l.presentfields = listappend(l.presentfields, l.idx)>
			</cfif>
		</cfloop>
				
		<cfset l.id = createuuid()>

		<cfquery name="l.q" datasource="#requestObject.getVar("dsn")#" result="m">
			INSERT INTO #variables.tabledata.tablename# (
				id,#l.presentfields#
			) VALUES (
				<cfqueryparam value="#l.id#" cfsqltype="cf_sql_varchar">
				<cfloop list="#l.presentfields#" index="l.idx">
					,<cfqueryparam value="#variables.itemdata[l.idx]#" cfsqltype="cf_sql_#variables.tabledata.fields[l.idx].type#">
				</cfloop>
			)
		</cfquery>

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
		
		<!--- remove id 
		<cfif >
		<cfset listdeleteat(l.presentfields,listfindnocase(l.presentfields,"id"))>
		--->
		<cftry>
		<cfquery name="l.q" datasource="#requestObject.getVar("dsn")#" result="m">
			UPDATE #variables.tabledata.tablename# SET
			<cfloop list="#l.presentfields#" index="l.idx">
				<cfif l.idx NEQ listfirst(l.presentfields)>,</cfif>
				#l.idx# = <cfqueryparam value="#variables.itemdata[l.idx]#" cfsqltype="cf_sql_#variables.tabledata.fields[l.idx].type#">
			</cfloop>
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfcatch>
			<cfoutput>
				
			UPDATE #variables.tabledata.tablename# SET<br>
			<cfloop list="#l.presentfields#" index="l.idx">
				<cfif l.idx NEQ listfirst(l.presentfields)>,</cfif>
				#l.idx# = &lt;cfqueryparam value="#variables.itemdata[l.idx]#" cfsqltype="cf_sql_#variables.tabledata.fields[l.idx].type#"><br/>
			</cfloop>
			WHERE id = &lt;cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		
			</cfoutput>
			<cfdump var=#cfcatch#>
			<cfabort>
		</cfcatch>
		</cftry>
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

		<cfquery name="lcl.query" datasource="#requestObject.getVar("dsn")#" result="m">
			DELETE FROM #variables.tabledata.tablename#
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			<cfif structkeyexists(variables.tabledata.fields, "siteid")>
				AND siteid = <cfqueryparam value="#variables.requestObject.getVar("siteid")#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="destroyBy">
		<cfargument name="field" required="true">
		<cfargument name="value" required="true">
		
		<cfset var lcl = structnew()>

		<cfquery name="lcl.query" datasource="#requestObject.getVar("dsn")#" result="m">
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
		
		<cfif hasfield("deleted") AND not structkeyexists(lcl.where, "deleted")>
			<cfset lcl.where.deleted = 0>
		</cfif>
		
		<cfif structkeyexists(variables.tabledata.fields, "siteid")>
			<cfset lcl.where.siteid = variables.requestObject.getVar("siteid")>
		</cfif>
		
		<cfset lcl.fieldlist = structkeylist(variables.tabledata.fields)>
		<cfset lcl.fieldlist = "#variables.tabledata.tablename#." & replace(lcl.fieldlist,",",", #variables.tabledata.tablename#.","all")>
		
		<cfset lcl.belongstodup = structnew()>
		<cfif structkeyexists(variables.tableData, "belongsTo")>
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
			FROM #variables.tabledata.tablename#
			
			<cfif structkeyexists(lcl, "belongsTodup")>
				<cfloop collection="#lcl.belongsToDup#" item="lcl.belongstokey">
					INNER JOIN 
					#listlast(lcl.belongstokey, ".")#
					ON
						#listlast(lcl.belongstokey, ".")#.id 
							= #variables.tabledata.tablename#.<cfif structkeyexists(lcl.belongsToDup[lcl.belongstokey], "foreignkey")>#lcl.belongsToDup[lcl.belongstokey].foreignkey#<cfelse>#rereplace(listlast(lcl.belongstokey, "."),"s$","")#id</cfif>
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
			
			<cfif structkeyexists(arguments.conditions,"sort")>
				ORDER BY #arguments.conditions.sort#
			<cfelseif this.hasfield("name") AND NOT structkeyexists(conditions, "count")>
				ORDER BY #variables.tabledata.tablename#.name
			</cfif>
		</cfquery>
		
		<cfif structkeyexists(conditions, "count")> 
			<cfreturn lcl.query.cnt>
		<cfelse>
			<cfreturn lcl.query>
		</cfif>
		
	</cffunction>

	
	<cffunction name="getAliasesSql">
		<cfset var s = "">
		<cfset var alidx = "">
		
		<cfif structkeyexists(variables.tabledata,"aliases")>
			<cfset s = "">
			<cfloop collection="#variables.tabledata.aliases#" item="alidx">
				<cfset s = s & "," & alidx & " = " & variables.tabledata.aliases[alidx]>
			</cfloop>
		</cfif>
		
		<cfreturn s>
	</cffunction>

</cfcomponent>