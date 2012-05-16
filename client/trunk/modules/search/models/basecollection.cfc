<cfcomponent name="basecollection">

	<cffunction name="init">
    	<cfargument name="requestObject" required="yes">
        <cfargument name="collectionName" required="yes">
        
        <cfset variables.requestObject = arguments.requestObject>
        <cfset variables.collectionname = arguments.collectionName>
        
        <cfset checkExists()>
            
		<cfreturn this>
	</cffunction>
	
	<cffunction name='getName'>
		<cfreturn variables.collectionname>
	</cffunction>
		
</cfcomponent>