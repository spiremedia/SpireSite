<cfcomponent name="imagerotator"  extends="resources.abstractObserver">
	<cffunction name="moduleoutput_imagerotator_default">
		<cfargument name="observed" required="true">

		<cfset observed.htmlhead = observed.htmlhead & '<div class="pocntntwrap">'>
		<cfset observed.htmlfoot = observed.htmlfoot & '</div>'>
	
		<cfreturn observed>
	</cffunction>
</cfcomponent>