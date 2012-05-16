<cfcomponent name="ajobservers"  extends="resources.abstractObserver">
	<cffunction name="moduleoutput_assetimages_default">
		<cfargument name="observed" required="true">

		<cfset observed.htmlhead = observed.htmlhead & '<div class="pocntntwrap">'>
		<cfset observed.htmlfoot = observed.htmlfoot & '</div>'>
	
		<cfreturn observed>
	</cffunction>
</cfcomponent>