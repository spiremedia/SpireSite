<cfcomponent name="blankEditable">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="default">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var contents="">
		<cfreturn contents>
	</cffunction>
	
	<cffunction name="notEmpty">
		<cfreturn false>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 10000>
	</cffunction>

</cfcomponent>