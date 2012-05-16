<cfcomponent name="indexable" extends="resources.abstractmodel">
	
	<cffunction name="init">
    	<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startOrm("indexables")>
        <cfreturn this>
	</cffunction>
	
	<cffunction name="setObjId">
		<cfargument name="objid" required="true">
		<cfset var lcl = structnew()>
		<cfset lcl.exists = this.getByObjId(arguments.objid)>
		<cfif lcl.exists.recordcount NEQ 0>
			<cfset this.setId(lcl.exists.id)>
		</cfif>
		<cfset setField("objid", objid)>
	</cffunction>
	
	<cffunction name="getNextIndexables">
		<cfargument name="limit" required="true">

		<cfset var lcl = structnew()>
	
		<cfquery name="lcl.next" datasource="#requestObject.getVar("dsn")#">
			SELECT TOP #limit# id, type, deleted, reindex, objid,
			CASE lastindexed 
				WHEN '' THEN CAST('1971-01-01' as datetime)
				ELSE lastindexed
			END as idxsort
			FROM indexables
			ORDER BY deleted DESC, reindex DESC, idxsort ASC, id
		</cfquery>

		<cfreturn lcl.next>
	</cffunction>
	 	
</cfcomponent>