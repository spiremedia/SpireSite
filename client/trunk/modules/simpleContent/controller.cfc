<cfcomponent name="simplecontent" extends="resources.abstractController">
	
	<cffunction name="showHTML">
		<cfparam name="variables.data.content" default="">
		<cfset var lcl = structnew()>
        <cfset variables.data.content = parseForLanguage( variables.data.content )>

        
		<cfif structkeyexists(variables, "title") AND variables.title NEQ "">
        	<cfset lcl.title = structnew()>
			<cfset lcl.title = variables.title>
			<cfset lcl.html = variables.data.content>
			<cfreturn lcl>
		<cfelse>
			<cfreturn variables.data.content>
		</cfif>
		
	</cffunction>
	
	<cffunction name="showReversionHTML">
        <cfreturn parseforlanguage( showHTML() )>
	</cffunction>
	
</cfcomponent>