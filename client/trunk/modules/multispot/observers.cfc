<cfcomponent name="multispotobservers"  extends="resources.abstractObserver">	
	<cffunction name="moduleoutput_multispot">
		<cfargument name="observed" required="true">

		<!--- <cfset observed.head = replace(observed.head,"po ","")>
		<cfset observed.foot = "</div>">
		<cfset observed.htmlfoot = "">
		<cfset observed.htmlhead = "">
		<cfset observed.tail = ""> --->
		<cfset observed.html = replacenocase(observed.html, """pocntntwrap""", """pocntntwrap""","all")>
		
		<cfreturn observed>
	</cffunction>
</cfcomponent>