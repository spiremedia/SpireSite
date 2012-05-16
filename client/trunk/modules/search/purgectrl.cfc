<cfcomponent extends="resources.abstractsubController" ouput="false">

	<cffunction name="init" output="false">
		<cfset var lcl = structnew()>
		<cfset super.init(argumentcollection = arguments)>
		
		<cfset var lcl = structnew()>
		
		<cfset lcl.collectionname = requestObject.getVar("collectionname", requestObject.getVar("sitename"))>
		<cfset lcl.collectiontype = requestObject.getVar("collectiontype", "cfsolr")>

		<cfset lcl.collection = createObject('component', 'modules.search.models.#lcl.collectiontype#').init(requestObject, lcl.collectionname)>
		
		<cfset lcl.collection.purge()>
		
		<cfreturn this>
	</cffunction>

  	<cffunction name="showHTML">
		<cfreturn "IndexPurged - please use clear/synch method">
	</cffunction>
	
</cfcomponent>