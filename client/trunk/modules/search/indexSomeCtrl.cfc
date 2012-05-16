<cfcomponent extends="resources.abstractsubController" ouput="false">

	<cffunction name="init" output="false">
		<cfset var lcl = structnew()>
		<cfset super.init(argumentcollection = arguments)>
      	<cfset variables.indexed = 0>
	 	
	 	<cfset lcl.collectionname = requestObject.getVar("collectionname", requestObject.getVar("sitename"))>
		<cfset lcl.collectiontype = requestObject.getVar("collectiontype", "cfsolr")>
        <cfset lcl.indexperrun = requestObject.getVar("indexperrun",500)>
		
		<!--- setup the collection object per the type --->
		<cfset lcl.collection = createObject('component', 'modules.search.models.#lcl.collectiontype#').init(requestObject, lcl.collectionname)>
		<cfset lcl.collection.checkexists()>

		<!--- item needed to index stuff --->
		<cfset lcl.indexable = createobject('component', 'modules.search.models.indexable').init(requestObject)>
		<cfif requestObject.isFormUrlVarSet("indexableid")>
			<cfset lcl.items = lcl.indexable.getById(requestObject.getFormUrlVar("indexableid"))>
		<cfelse>
			<cfset lcl.items = lcl.indexable.getNextIndexables(lcl.indexperrun)>
		</cfif>
	

		<!--- indexing --->
		<cfloop query="lcl.items">
			<cfif lcl.items.deleted>
				<cfset lcl.collection.delete(lcl.items.objid)>
				<!--- <cfset lcl.indexable.setId()> --->
				<cfquery name="destroy" datasource="#requestObject.getVar("dsn")#" result="m">
					DELETE FROM indexables WHERE id = <cfqueryparam value="#lcl.items.id#" cfsqltype="cf_sql_varchar">
				</cfquery>
			<cfelse>
				<cfset lcl.indexer = lcl.collection.getIndexer(lcl.items.type)>
				<cfset lcl.indexable.clear()>
				<cfset lcl.indexable.load(lcl.items.id)>
				<cfset lcl.indexer.setCollection(lcl.collection) >
				<cfset lcl.indexer.process(lcl.indexable)>
				<cfset variables.indexed = variables.indexed + 1>
			</cfif>
		</cfloop>
		
		<cfset lcl.collection.commit()>

		<cfreturn this>
	</cffunction>
    
	<cffunction name="showHTML">
		<cfset var html = "">
		<cfsavecontent variable="html">
		<cfif requestobject.isformurlvarset("loop")>
			<script>
				location.href= '/system/refreshsearch/indexsome?loop=1';
			</script>
		</cfif>
		Indexed <cfoutput>#variables.indexed#</cfoutput>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>  

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
    
</cfcomponent>