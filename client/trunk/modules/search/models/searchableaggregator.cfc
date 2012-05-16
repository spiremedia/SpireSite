<cfcomponent extends="resources.abstractController" ouput="false">
	
    <cffunction name="init" output="false">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.aggregatedcnt = 0>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="newIndexable">
    	<cfreturn createObject('component', "modules.search.models.indexable").init(requestObject)>
    </cffunction>
    
    <!--- <cffunction name="newFileIndexable">
    	<cfreturn createObject('component', "modules.search.models.fileIndexable").init(this)>
    </cffunction>
  --->
	<!--- 
    <cffunction name="getPageIndexables">
    	<cfreturn variables.pageindexables>
    </cffunction>
    
    <cffunction name="getFileIndexables">
    	<cfreturn variables.fileindexables> 
    </cffunction>
     --->
	
    <cffunction name="saveFileIndexable">
    	<cfargument name="itm" required="yes">
    	<cfset arrayappend(variables.fileindexables, itm)> 
    </cffunction>
    
    <cffunction name="save">
    	<cfargument name="itm" required="yes">
		<cfset variables.aggregatedcnt = variables.aggregatedcnt + 1>
		<cfif NOT itm.save()>
			<cfset itm.getValidator().dump()>
			<cfabort>
		</cfif>
    </cffunction>
	
	<cffunction name="getAggregatedCount">
		<cfreturn variables.aggregatedcnt>
	</cffunction>

</cfcomponent>