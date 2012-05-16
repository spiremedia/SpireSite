<cfcomponent extends="resources.abstractsubController" ouput="false">

	<cffunction name="init" output="false">
		<cfset var lcl = structnew()>
		<cfset super.init(argumentcollection = arguments)>
	
        <cfquery name="lcl.m" datasource="#requestObject.getVar("dsn")#">
			DELETE FROM indexables
		</cfquery>
		
		<cfreturn this>
	</cffunction>

  	<cffunction name="showHTML">
		<cfreturn "Indexables Cleared - please use synch method">
	</cffunction>
	
</cfcomponent>