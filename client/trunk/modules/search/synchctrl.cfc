<cfcomponent extends="resources.abstractsubController" ouput="false">

	<cffunction name="init" output="false">
		<cfset super.init(argumentcollection = arguments)>

        <cfset variables.aggregator = createobject('component','modules.search.models.searchableaggregator').init(requestObject)>
		
		<cfset requestObject.notifyObservers("search.synchsearchables", variables.aggregator)>
		
		<cfreturn this>
	</cffunction>

  	<cffunction name="showHTML">
		<cfreturn "synched " & variables.aggregator.getAggregatedCount()>
	</cffunction>
	
</cfcomponent>