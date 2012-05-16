<cfcomponent name="taxonomy Object Relator Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="loadByObj">
		<cfargument name="objid" required="true">
		<cfargument name="objtype" required="true">
		<cfargument name="taxonomyid" required="false">
		
		<cfset var lcl = structnew()>
		
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT ti.taxonomyid,
					ti.id
			FROM taxonomyrelations tr
			INNER JOIN taxonomyItems ti ON ti.id = tr.taxonomyItemId
			WHERE tr.relationid = <cfqueryparam value="#arguments.objid#" cfsqltype="cf_sql_varchar">
				<cfif structkeyexists(arguments, "taxonomyid")>
					AND ti.taxonomyid = <cfqueryparam value="#arguments.taxonomyid#" cfsqltype="cf_sql_varchar">
				</cfif>
		</cfquery>
		
		<cfset lcl.r = structnew()>
		<cfloop query="lcl.q">
			<cfif NOT structkeyexists(lcl.r, taxonomyid)>
				<cfset lcl.r[taxonomyid] = structnew()>
			</cfif>
			<cfset lcl.r[taxonomyid][id] = 1>
		</cfloop>
		
		<cfif structkeyexists(arguments, "taxonomyid")>
			<cfreturn lcl.r[arguments.taxonomyid]>
		</cfif>
		
		<cfreturn lcl.r>
	</cffunction>
	
	<cffunction name="saveToObj">
		<cfargument name="objid" required="true">
		<cfargument name="objtype" required="true">
		<cfargument name="taxonomyid" required="true">
		<cfargument name="taxonomyitemids" required="true">
		
		<cfset var lcl = structnew()>

		<!--- <cfdump var=#arguments#> --->
		<!--- remove extras --->
		<cfquery name="lcl.rmextras" datasource="#requestObj.getVar("dsn")#" result="m">
			DELETE tr	
			FROM  taxonomyrelations tr
			INNER JOIN taxonomyItems ti ON tr.taxonomyItemId = ti.id
			WHERE 
				tr.relationtype = <cfqueryparam value="#arguments.objtype#" cfsqltype="cf_sql_varchar">
				AND tr.taxonomyitemid NOT IN (<cfqueryparam value="#arguments.taxonomyitemids#" list="true" cfsqltype="cf_sql_varchar">) 
				AND tr.relationid = <cfqueryparam value="#arguments.objid#" cfsqltype="cf_sql_varchar">
				AND ti.taxonomyid = <cfqueryparam value="#arguments.taxonomyid#" cfsqltype="cf_sql_varchar">
				AND tr.siteid = <cfqueryparam value="#userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<!--- <cfdump var=#m#>	 --->
		
		<!--- add not ins --->
		<cfquery name="lcl.addnotins" datasource="#requestObj.getVar("dsn")#" result="m">
			INSERT INTO taxonomyrelations (taxonomyitemid, relationtype, relationid, siteid)
			SELECT 
				ti.id,
				<cfqueryparam value="#arguments.objtype#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.objid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">	
			FROM taxonomyitems ti
			LEFT OUTER JOIN taxonomyrelations tr ON 
				tr.taxonomyitemid = ti.id
				AND tr.relationid = <cfqueryparam value="#arguments.objid#" cfsqltype="cf_sql_varchar">
				AND tr.relationtype = <cfqueryparam value="#arguments.objtype#" cfsqltype="cf_sql_varchar">
				AND tr.siteid = <cfqueryparam value="#userObj.getCurrentSiteId("siteid")#" cfsqltype="cf_sql_varchar">
			WHERE 
				ti.id IN (<cfqueryparam value="#arguments.taxonomyitemids#" list="true" cfsqltype="cf_sql_varchar">) 
				AND ti.taxonomyid = <cfqueryparam value="#arguments.taxonomyid#" cfsqltype="cf_sql_varchar">
				AND tr.id IS NULL
		</cfquery>
		
		<!--- <cfdump var=#m#>
		<cfabort>	 --->
		<!--- TODO, if dates appear on relations, add here --->
	</cffunction>
	
</cfcomponent>
